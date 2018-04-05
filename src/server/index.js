const express = require("express")
const bodyParser = require("body-parser")
const model = require("./model.js")
const port = 3000

const app = express()
app.use(bodyParser.json())

let prevPlayerId = -99

let board = [
    ['', '', ''],
    ['', '', ''],
    ['', '', '']
]

app.get('/version', (req, res) => {
    res.send('Api Version v0.0.1');
});

app.get("/", (req, res) => {
    res.json({ board })
})

app.post("/action", (req, res) => {
    let action = req.body
    let playerId = action.playerId
    let x = action.x
    let y = action.y

    if (playerId != prevPlayerId && playerId >= 0 && playerId <= 1 && x >= 0 && x <= 2 && y >= 0 && y <= 2) {
        if (board[x][y] == '') {
            switch(playerId) {
                case 0: 
                    board[x][y] = 'X'
                    break
                case 1:
                    board[x][y] = 'O'
                    break
                default: 
                    board[x][y] = ''
                    break
            }
            if (!checkWin(playerId)) {
                prevPlayerId = playerId
                res.send('Seems fine! (but you did not win...)' + JSON.stringify(action))
            } else {
                res.send('Player with id: ' + playerId + ' won!')
            }
        } else {
            res.send('This board position is already in use ' + JSON.stringify(action))
        }
    } else {
        res.send('Your request seems invalid ' + JSON.stringify(action))
    }
})

app.listen(port, err => {
    if (err) {
        console.log("oje", err)
    } else {
        console.log("listening on port " + port)
    }
})

function checkWin(playerId) {
    let lastPlayerSign = playerId == 0 ? 'X' : 'O'
    let result = false

    for (let i = 0; i <= 2; i++) {
        let horizontal = true
        for (let j = 0; j <= 2; j++) {
            if (board[i][j] != lastPlayerSign ) {
                horizontal = false
            } 
        }
        if (horizontal) {
            result = true
        }
    }

    for (let j = 0; j <= 2; j++) {
        let vertical = true
        for (let i = 0; i <= 2; i++) {
            if (board[i][j] != lastPlayerSign ) {
                vertical = false
            } 
        }
        if (vertical) {
            result = true
        }
    }

    let diagonal1 = true
    let diagonal2 = true 

    for (let i = 0; i <= 2; i++) {
        if (board[i][2 - i] != lastPlayerSign ) { diagonal1 = false }
        if (board[2 - i][i] != lastPlayerSign ) { diagonal2 = false }
    }
    
    if (diagonal1 || diagonal2) {
        result = true
    }

    return result

}
