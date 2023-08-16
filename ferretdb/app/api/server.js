const express = require('express');
const app = express();
const cors = require('cors');
const port = 8080;
const path = require('path');

const tasksRoutes = require("./routes/tasksRoutes");

app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cors({ origin: '*' }));

if (process.env.NODE_ENV === 'production') {
	app.use(express.static('client/build'));
}

app.use("/api/tasks", tasksRoutes);

app.get("/*", (req, res) => {
    res.sendFile(path.join(__dirname, "/client/build/index.html"));
});

app.use((err, req, res, next) => {
    res.status(422).send({ error: err._message });
});

// console.log that your server is up and running
app.listen(port, () => console.log(`Listening on port ${port}`));

