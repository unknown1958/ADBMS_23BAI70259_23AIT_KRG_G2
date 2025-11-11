db.createCollection("cars")
db.cars.insertOne({
  "maker": "Tata",
  "model": "Nexon",
  "fuel_type": "Petrol",
  "transmission": "Automatic",
  "engine": {
    "type": "Turbocharged",
    "cc": 1199,
    "torque": "170 Nm"
  },
  "features": [
    "Touchscreen",
    "Reverse Camera",
    "Bluetooth Connectivity"
  ],
  "sunroof": false,
  "airbags": 2
})
db.cars.find().pretty()
db.cars.insertMany([{"maker":"Tata","model":"Nexon","fuel_type":"Petrol","transmission":"Automatic","engine":{"type":"Turbocharged","cc":1199,"torque":"170 Nm"},"features":["Touchscreen","Reverse Camera","Bluetooth Connectivity"],"sunroof":false,"airbags":2},{"maker":"Hyundai","model":"Creta","fuel_type":"Diesel","transmission":"Manual","engine":{"type":"CRDi","cc":1493,"torque":"250 Nm"},"features":["Sunroof","ABS","Touchscreen"],"sunroof":true,"airbags":6},{"maker":"Maruti","model":"Swift","fuel_type":"Petrol","transmission":"Manual","engine":{"type":"Naturally Aspirated","cc":1197,"torque":"113 Nm"},"features":["Bluetooth Connectivity","Power Windows"],"sunroof":false,"airbags":2}])
db.cars.find()
db.cars.findOne()
db.cars.find({}, { model: 1, _id: 0 })
db.cars.find({ "fuel_type": "Petrol" })
db.cars.updateOne(
  { model: "Nexon" },
  { $set: { color: "Red" } }
)
db.cars.find({ model: "Nexon" }).pretty()
db.cars.updateOne(
  { model: "Nexon" },
  { $push: { features: "Heated Seats" } }
)
db.cars.find({ model: "Nexon" }).pretty()
db.cars.updateOne(
  { model: "Nexon" },
  { $pull: { features: "Heated Seats" } }
)
db.cars.find({ model: "Nexon" }).pretty()
db.cars.updateMany(
  { fuel_type: "Diesel" },
  { $set: { alloys: "yes" } }
)
db.cars.find({ fuel_type: "Diesel" }).pretty()
db.cars.updateOne(
  { model: "Nexon" },
  { $push: { features: { $each: ["Wireless charging", "Voice Control"] } } }
)
db.cars.find({ model: "Nexon" }).pretty()
db.cars.updateOne(
  { model: "Nexon" },
  { $unset: { color: "" } }
)
db.cars.find({ model: "Nexon" }).pretty()
db.cars.aggregate([
  {
    $group: {
      _id: "$maker",
      TotalCars: { $sum: 1 }
    }
  }
])
db.cars.aggregate([
  {
    $group: {
      _id: "$fuel_type",
      TotalCars: { $sum: 1 }
    }
  }
])
