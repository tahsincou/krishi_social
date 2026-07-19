const jsonServer = require('json-server');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const cors = require('cors');
const fs = require('fs');
const path = require('path');

const server = jsonServer.create();
const router = jsonServer.router(
  path.join(__dirname, 'db.json'),
);
const middlewares = jsonServer.defaults();

const PORT = 3001;
const JWT_SECRET = 'krishi-media-demo-secret';

server.use(cors());
server.use(middlewares);

// Use only one JSON body parser.
server.use(jsonServer.bodyParser);

function readDatabase() {
  return JSON.parse(
    fs.readFileSync(
      path.join(__dirname, 'db.json'),
      'utf8',
    ),
  );
}

function writeDatabase(data) {
  fs.writeFileSync(
    path.join(__dirname, 'db.json'),
    JSON.stringify(data, null, 2),
  );
}

server.get('/health', (_, response) => {
  response.json({
    status: 'ok',
    server: 'krishi-custom-server',
  });
});

server.post('/auth/login', async (request, response) => {
  const email = String(request.body?.email ?? '')
    .trim()
    .toLowerCase();

  const password = String(
    request.body?.password ?? '',
  );

  const database = readDatabase();

  const user = (database.users ?? []).find(
    (item) =>
      String(item.email ?? '')
        .trim()
        .toLowerCase() === email,
  );

  if (!user) {
    return response.status(401).json({
      message: 'Invalid email or password',
    });
  }

  const passwordMatches = user.passwordHash
    ? await bcrypt.compare(password, user.passwordHash)
    : user.password === password;

  if (!passwordMatches) {
    return response.status(401).json({
      message: 'Invalid email or password',
    });
  }

  const token = jwt.sign(
    {
      sub: user.id,
      email: user.email,
    },
    JWT_SECRET,
    {
      expiresIn: '7d',
    },
  );

  const {
    password: ignoredPassword,
    passwordHash: ignoredPasswordHash,
    ...safeUser
  } = user;

  return response.json({
    ...safeUser,
    token,
  });
});

server.post('/auth/register', async (request, response) => {
  const {
    name,
    phone,
    email,
    password,
    location,
    activity,
  } = request.body;

  const database = readDatabase();
  database.users ??= [];

  const existingUser = database.users.find(
    (item) =>
      String(item.email ?? '').toLowerCase() ===
      String(email ?? '').toLowerCase(),
  );

  if (existingUser) {
    return response.status(409).json({
      message: 'An account already exists with this email',
    });
  }

  const user = {
    id: `user-${Date.now()}`,
    name,
    phone,
    email,
    passwordHash: await bcrypt.hash(password, 10),
    location,
    activity,
    verificationStatus: 'pending',
  };

  database.users.push(user);
  writeDatabase(database);

  const token = jwt.sign(
    {
      sub: user.id,
      email: user.email,
    },
    JWT_SECRET,
    {
      expiresIn: '7d',
    },
  );

  const {
    passwordHash,
    ...safeUser
  } = user;

  return response.status(201).json({
    ...safeUser,
    token,
  });
});

// Keep this after custom routes.
server.use(router);

server.listen(PORT, '0.0.0.0', () => {
  console.log(
    `Krishi mock server running on port ${PORT}`,
  );
});