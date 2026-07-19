const jsonServer = require('json-server');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const cors = require('cors');
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
server.use(jsonServer.bodyParser);

server.get('/health', (_, response) => {
  response.json({
    status: 'ok',
    server: 'krishi-mock-server',
  });
});

server.post('/auth/login', async (request, response) => {
  try {
    const email = String(request.body?.email ?? '')
      .trim()
      .toLowerCase();

    const password = String(request.body?.password ?? '');

    if (!email || !password) {
      return response.status(400).json({
        message: 'Email and password are required',
      });
    }

    const user = router.db
      .get('users')
      .find((item) => {
        return (
          String(item.email ?? '').trim().toLowerCase() === email
        );
      })
      .value();

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
  } catch (error) {
    console.error('Login failed:', error);

    return response.status(500).json({
      message: 'Login failed',
    });
  }
});

server.post('/auth/register', async (request, response) => {
  try {
    const {
      name,
      phone,
      email,
      password,
      location,
      activity,
    } = request.body ?? {};

    const normalizedEmail = String(email ?? '')
      .trim()
      .toLowerCase();

    if (
      !name ||
      !phone ||
      !normalizedEmail ||
      !password ||
      !location ||
      !activity
    ) {
      return response.status(400).json({
        message: 'All required fields must be provided',
      });
    }

    const existingUser = router.db
      .get('users')
      .find((item) => {
        return (
          String(item.email ?? '').trim().toLowerCase() ===
          normalizedEmail
        );
      })
      .value();

    if (existingUser) {
      return response.status(409).json({
        message: 'An account already exists with this email',
      });
    }

    const user = {
      id: `user-${Date.now()}`,
      name: String(name).trim(),
      phone: String(phone).trim(),
      email: normalizedEmail,
      passwordHash: await bcrypt.hash(String(password), 10),
      location: String(location).trim(),
      activity,
      verificationStatus: 'pending',
    };

    router.db
      .get('users')
      .push(user)
      .write();

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
      passwordHash: ignoredPasswordHash,
      ...safeUser
    } = user;

    return response.status(201).json({
      ...safeUser,
      token,
    });
  } catch (error) {
    console.error('Registration failed:', error);

    return response.status(500).json({
      message: 'Registration failed',
    });
  }
});

server.use((request, _, next) => {
  console.log(
    `${request.method} ${request.path}`,
    request.body ?? '',
  );

  next();
});

server.use(router);

server.use((error, request, response, next) => {
  console.error(
    `Request failed: ${request.method} ${request.path}`,
    error,
  );

  if (response.headersSent) {
    return next(error);
  }

  return response.status(500).json({
    message: error.message || 'Server error',
  });
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`Krishi mock server running on port ${PORT}`);
  console.log(`Local: http://localhost:${PORT}`);
});