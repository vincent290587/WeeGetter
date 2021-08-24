const https = require('https')

const options = {
  hostname: 'intervals.icu',
  port: 443,
  path: '/api/v1/athlete/i30899/events?oldest=2021-08-24&newest=2021-08-24',
  method: 'GET',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Basic QVBJX0tFWTo1YW5ka2w2bW1xd3FodGFuZDF4a3dpemF2',
  },
}

const optionsW = {
  hostname: 'intervals.icu',
  port: 443,
  path: '/api/v1/athlete/i30899/events/1399189/download.zwo',
  method: 'GET',
  headers: {
    'Authorization': 'Basic QVBJX0tFWTo1YW5ka2w2bW1xd3FodGFuZDF4a3dpemF2',
  },
}

// GET https://intervals.icu/api/v1/athlete/i30899/events/1399189/download.zwo

callback2 = function(response) {
  var str = ''
  response.on('data', function (chunk) {
    str += chunk;
  });

  response.on('end', function () {
    console.log(str);
  });
}

callback = function(response) {
    var str = ''
    response.on('data', function (chunk) {
      str += chunk;
    });
  
    response.on('end', function () {
      console.log(str);
    });

    const req2 = https.request(optionsW, callback2)

    req2.on('error', error => {
      console.error(error)
    })

    req2.end()
  }

const req = https.request(options, callback)

req.on('error', error => {
  console.error(error)
})

req.end()