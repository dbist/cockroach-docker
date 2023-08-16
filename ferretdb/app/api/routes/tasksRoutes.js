let express = require("express"),
    router = express.Router(),
    db = require('../db'),
    ObjectId = require('mongodb').ObjectId;

// GET 
router.get("/", async (req, res, next) => {
    const database = await db('todo');
    const tasks = await database.collection("tasks").find().toArray();
    tasks.forEach(obj => renameKey(obj, '_id', 'id'));
    res.send(tasks);
});

function renameKey(obj, oldKey, newKey) {
    obj[newKey] = obj[oldKey];
    delete obj[oldKey];
}

// POST
router.post("/", async (req, res, next) => {
    let task = req.body;
    const database = await db('todo');
    const result = await database.collection("tasks").insertOne(task);
    res.send(result);
});

// PUT 
router.put("/", async (req, res, next) => {
    let task = req.body;
    const database = await db('todo');
    const result = await database.collection('tasks').updateOne(
        { "_id": ObjectId(task.id) },
        { $set: task }
    );
    res.send(result);
});

// DELETE
router.delete("/", async (req, res, next) => {
    const id = req.query.id;
    const database = await db('todo');
    const result = await database.collection('tasks').deleteOne(
        { "_id": ObjectId(id) }
    );
    res.send(result);
});

module.exports = router;