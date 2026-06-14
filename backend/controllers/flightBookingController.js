const FlightBooking = require("../models/FlightBooking");
const { markPromoUsed } = require("./promoController");

exports.createFlightBooking = async (req, res) => {
  try {

    const booking = new FlightBooking({
      ...req.body,
      user: req.user._id   // ✅ اربط الحجز بالمستخدم
    });

    await booking.save();

    // after booking is saved:
    if (req.body.promoCode) {
      await markPromoUsed(req.user._id, req.body.promoCode);
    }

    res.status(201).json({
      message: "Flight booked successfully",
      booking,
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server Error" });
  }
};
