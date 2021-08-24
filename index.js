const https = require('https')

const options = {
  hostname: 'intervals.icu',
  port: 443,
  path: '/api/v1/athlete/i30899/events?oldest=2021-08-23&newest=2021-08-24',
  method: 'GET',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Basic QVBJX0tFWTo1YW5ka2w2bW1xd3FodGFuZDF4a3dpemF2',
  },
}

callback = function(response) {
    var str = ''
    response.on('data', function (chunk) {
      str += chunk;
    });
  
    response.on('end', function () {
      console.log(str);
    });
  }

const req = https.request(options, res => {

  console.log(`statusCode: ${res.statusCode}`)

  res.on('data', d => {
    process.stdout.write(d)
  })
})

req.on('error', error => {
  console.error(error)
})

req.end()