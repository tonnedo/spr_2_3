const express = require('express');
const bodyParser = require('body-parser');
const { exec } = require('child_process');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = 3000;

app.use(bodyParser.json());
app.use(express.static(__dirname));

app.post('/recommend', (req, res) => {
    const input = req.body;

    // Формируем CLIPS-скрипт
    let script = `(clear)\n(load "rules.clp")\n(reset)\n`;

    if (input.price && !isNaN(parseInt(input.price))) {
        const budget = parseInt(input.price);
        script += `(assert (need price ${budget}))\n`;
    }

    script += `(run)\n(facts)\n(exit)\n`;

    const filePath = "/tmp/input.clp";
    fs.writeFileSync(filePath, script);

    exec(`clips -f ${filePath}`, (error, stdout) => {
        console.log("CLIPS output:\n", stdout); // Отладка

        let recommendation = null;
        if (stdout.includes('(recommend tariff_id 1)')) recommendation = 'Безлимитный';
        else if (stdout.includes('(recommend tariff_id 2)')) recommendation = 'Эконом';
        else if (stdout.includes('(recommend tariff_id 3)')) recommendation = 'Минимум';
        else if (stdout.includes('(recommend tariff_id 4)')) recommendation = 'Супернет';

        res.json({ recommendation });
    });
});

app.listen(PORT, () => {
    console.log(`Сервер запущен на http://localhost:${PORT}`);
});