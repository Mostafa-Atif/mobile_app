const PromoCode = require("../models/PromoCode");
const User = require("../models/User");

exports.validatePromo = async (req, res) => {
  try {
    const { code, userId } = req.body;

    const promo = await PromoCode.findOne({ code: code.toUpperCase(), isActive: true });
    if (!promo) return res.status(404).json({ message: "Invalid promo code" });

    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: "User not found" });

    if (user.usedPromoCodes.includes(code.toUpperCase()))
      return res.status(400).json({ message: "Promo code already used" });

    res.json({ discountPercent: promo.discountPercent });
  } catch (err) {
    res.status(500).json({ message: "Server error" });
  }
};

exports.markPromoUsed = async (userId, code) => {
  await User.findByIdAndUpdate(userId, {
    $push: { usedPromoCodes: code.toUpperCase() },
  });
};