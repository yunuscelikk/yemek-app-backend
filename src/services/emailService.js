const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST || 'smtp.gmail.com',
  port: parseInt(process.env.SMTP_PORT) || 587,
  secure: false,
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS,
  },
});

const sendMail = async (to, subject, html) => {
  if (!process.env.SMTP_USER) {
    console.log(`[Email] SMTP yapılandırılmamış. Konu: ${subject}, Alıcı: ${to}`);
    return;
  }

  await transporter.sendMail({
    from: process.env.SMTP_FROM || process.env.SMTP_USER,
    to,
    subject,
    html,
  });
};

const sendVerificationEmail = async (email, token) => {
  const url = `${process.env.APP_URL || 'http://localhost:3000'}/api/auth/verify-email?token=${token}`;
  await sendMail(email, 'Bitir Yemek - E-posta Doğrulama', `
    <h2>E-posta Doğrulama</h2>
    <p>Hesabınızı doğrulamak için aşağıdaki bağlantıya tıklayın:</p>
    <a href="${url}">${url}</a>
    <p>Bu bağlantı 24 saat geçerlidir.</p>
  `);
};

const sendPasswordResetEmail = async (email, token) => {
  const url = `${process.env.APP_URL || 'http://localhost:3000'}/api/auth/reset-password?token=${token}`;
  await sendMail(email, 'Bitir Yemek - Şifre Sıfırlama', `
    <h2>Şifre Sıfırlama</h2>
    <p>Şifrenizi sıfırlamak için aşağıdaki bağlantıya tıklayın:</p>
    <a href="${url}">${url}</a>
    <p>Bu bağlantı 1 saat geçerlidir.</p>
  `);
};

const sendOrderStatusEmail = async (email, orderStatus, pickupCode) => {
  const statusMap = {
    confirmed: 'onaylandı',
    picked_up: 'teslim alındı',
    cancelled: 'iptal edildi',
  };
  await sendMail(email, `Bitir Yemek - Sipariş ${statusMap[orderStatus] || orderStatus}`, `
    <h2>Sipariş Durumu Güncellendi</h2>
    <p>Siparişiniz <strong>${statusMap[orderStatus] || orderStatus}</strong>.</p>
    ${pickupCode ? `<p>Teslim alma kodunuz: <strong>${pickupCode}</strong></p>` : ''}
  `);
};

module.exports = {
  sendMail,
  sendVerificationEmail,
  sendPasswordResetEmail,
  sendOrderStatusEmail,
};
