const ContactMessage = require("../models/ContactMessage");
const nodemailer = require("nodemailer");

exports.sendMessage = async (req, res) => {
  try {
    const { firstName, lastName, email, phone, subject, message } = req.body;

    // 1️⃣ حفظ في الداتا بيز
    const savedMessage = await ContactMessage.create({
      firstName,
      lastName,
      email,
      phone,
      subject,
      message,
    });

    // 2️⃣ إرسال Email
    const transporter = nodemailer.createTransport({
      host: "smtp.gmail.com",
      port: 587,          // 👈 مهم
      secure: false,      // 👈 مهم (لازم false مع 587)
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
      },
    });

    await transporter.sendMail({
      from: `"Rahal Contact" <${process.env.EMAIL_USER}>`,
      to: process.env.EMAIL_USER,
      subject: `📩 New Contact Message - ${subject}`,
      text: `
Name: ${firstName} ${lastName}
Email: ${email}
Phone: ${phone}

Message:
${message}
      `,
    });

    res.status(201).json({ message: "Message sent successfully" });

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
};
