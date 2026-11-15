use meronic_catalogue;

// Find active properties in Lagos.
db.properties.find(
  { active: true, "location.city": "Lagos" },
  { propertyName: 1, propertyType: 1, amenities: 1, _id: 0 }
);

// Find properties with nightly room type rates no greater than NGN 100,000.
db.properties.find({
  active: true,
  roomTypes: { $elemMatch: { baseRate: { $lte: 100000 } } }
});

// Find catalogue entries with a kitchen amenity.
db.properties.find({ amenities: "Kitchen" });

// Aggregate property count by city and type.
db.properties.aggregate([
  { $match: { active: true } },
  { $group: { _id: { city: "$location.city", type: "$propertyType" }, propertyCount: { $sum: 1 } } },
  { $sort: { "_id.city": 1, propertyCount: -1 } }
]);

// Indexes for common catalogue searches.
db.properties.createIndex({ "location.city": 1, propertyType: 1, active: 1 });
db.properties.createIndex({ "roomTypes.baseRate": 1 });
db.properties.createIndex({ amenities: 1 });
db.properties.createIndex({ "location.coordinates": "2dsphere" });

// Inspect query plan and indexes.
db.properties.find({ "location.city": "Lagos", active: true }).explain("executionStats");
db.properties.getIndexes();
