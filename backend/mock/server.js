const express = require('express');
const jsonServer = require('json-server');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const cors = require('cors');
const fs = require('fs');
const path = require('path');

const app = express();
const router = jsonServer.router(path.join(__dirname, 'db.json'));
const middlewares = jsonServer.defaults();

const PORT = 3001;
const JWT_SECRET = 'krishi-media-demo-secret';

app.use(cors());
app.use(express.json());
app.use(middlewares);

function readDatabase() {
  return JSON.parse(
    fs.readFileSync(path.join(__dirname, 'db.json'), 'utf8'),
  );
}

function writeDatabase(data) {
  fs.writeFileSync(
    path.join(__dirname, 'db.json'),
    JSON.stringify(data, null, 2),
  );
}

app.post('/auth/login', async (req, res) => {
  console.log('Login request received:', req.body);

  const email = String(req.body?.email ?? '').trim().toLowerCase();
  const password = String(req.body?.password ?? '');

  if (!email || !password) {
    return res.status(400).json({
      message: 'Email and password are required',
    });
  }

  const database = readDatabase();

  console.log('Users found:', database.users);

  const user = (database.users ?? []).find(
    (item) =>
      String(item.email ?? '').trim().toLowerCase() === email,
  );

  if (!user) {
    return res.status(401).json({
      message: 'Invalid email or password',
    });
  }

  const passwordMatches = user.passwordHash
    ? await bcrypt.compare(password, user.passwordHash)
    : user.password === password;

  if (!passwordMatches) {
    return res.status(401).json({
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

  return res.json({
    ...safeUser,
    token,
  });
});

app.post('/auth/register', async (req, res) => {
  const {
    name,
    phone,
    email,
    password,
    location,
    activity,
  } = req.body;

  const database = readDatabase();
  database.users ??= [];

  const existingUser = database.users.find(
    (item) => item.email?.toLowerCase() === email?.toLowerCase(),
  );

  if (existingUser) {
    return res.status(409).json({
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

  const { passwordHash, ...safeUser } = user;

  return res.status(201).json({
    ...safeUser,
    token,
  });
});
app.get("/health", (req, res) => {
  res.json({
    status: "ok",
    server: "custom-auth-server",
  });
});

app.use(router);

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Krishi mock server running on port ${PORT}`);
  console.log(`LAN access: http://192.168.1.105:${PORT}`);
});