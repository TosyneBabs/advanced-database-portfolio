// Run with mongosh
use meronic_catalogue;

db.properties.drop();

db.properties.insertMany([
  {
    _id: "PROP-LAGOS-001",
    propertyName: "Meronic Lagos Waterfront Hotel",
    propertyType: "hotel",
    ownerRef: "22222222-2222-4222-8222-222222222222",
    location: { city: "Lagos", state: "Lagos", country: "Nigeria", coordinates: { type: "Point", coordinates: [3.395, 6.455] } },
    currency: "NGN",
    description: "City hotel with leisure and business facilities.",
    amenities: ["Wi-Fi", "Swimming pool", "Parking"],
    roomTypes: [
      { code: "STD-Q", name: "Standard Queen", maxOccupancy: 2, baseRate: 85000 },
      { code: "EXEC-S", name: "Executive Suite", maxOccupancy: 3, baseRate: 165000 }
    ],
    policies: { checkIn: "14:00", checkOut: "11:00", cancellation: "Moderate" },
    tags: ["business", "city", "hotel"],
    active: true
  },
  {
    _id: "PROP-LEKKI-002",
    propertyName: "Meronic Lekki Serviced Apartments",
    propertyType: "serviced_apartment",
    ownerRef: "22222222-2222-4222-8222-222222222222",
    location: { city: "Lagos", state: "Lagos", country: "Nigeria" },
    currency: "NGN",
    description: "Furnished serviced apartments for short and extended stays.",
    amenities: ["Wi-Fi", "Kitchen", "Parking", "Air conditioning"],
    roomTypes: [
      { code: "1BR", name: "One Bedroom Apartment", maxOccupancy: 2, baseRate: 110000 }
    ],
    policies: { checkIn: "15:00", checkOut: "12:00", cancellation: "Flexible" },
    tags: ["apartment", "long-stay", "family"],
    active: true
  },
  {
    _id: "PROP-ABUJA-003",
    propertyName: "Meronic Abuja Short Lets",
    propertyType: "short_let",
    ownerRef: "22222222-2222-4222-8222-222222222222",
    location: { city: "Abuja", state: "FCT", country: "Nigeria" },
    currency: "NGN",
    description: "Entire apartment for short stays.",
    amenities: ["Wi-Fi", "Kitchen", "Air conditioning"],
    roomTypes: [
      { code: "ENTIRE", name: "Entire Apartment", maxOccupancy: 4, baseRate: 95000 }
    ],
    policies: { checkIn: "14:00", checkOut: "11:00", cancellation: "Strict" },
    tags: ["short-let", "entire-place"],
    active: true
  }
]);

print("Inserted property catalogue documents:");
db.properties.find({}, {propertyName: 1, propertyType: 1, "location.city": 1}).forEach(printjson);
