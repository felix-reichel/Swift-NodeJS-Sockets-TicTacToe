const express = require("express")
const bodyParser = require("body-parser")
const port = 8080
const model = require("./model.js")

const app = express()

app.use(bodyParser.json())

app.get("/", (request, response) => {
    response.json({board})
})


/*
    POST FOR USER ACTION: http://localhost:8080/action
    {
	"playerId": 1,
	"x": 0,
	"y": 0
    }   

*/

app.post("/action", (request, response) => {
    response.send('Got a POST request' + JSON.stringify(request.body));
    // request verwenden
    // überprüfen ob am gesetzt -> setzten
    // auf win überprüfen
    // game zurückschicken

})

app.listen(port, err => {
    if (err) {
        console.log("oje", err)
    } else {
        console.log("listening on port " + port)
    }
})