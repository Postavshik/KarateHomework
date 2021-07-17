function fn() {
  var env = karate.env; // get system property 'karate.env'

  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }

  var config = {
    apiUrl: 'https://conduit.productionready.io/api'
  }

  if (env == 'dev') {
    config.userEmail = 'calvario_test@test.com'
    config.userPassword = '12345678'
    config.username = 'calvario31' 
  } else if (env == 'qa') {
    config.userEmail = 'calvario_test@test.com'
    config.userPassword = '12345678'
    config.username = 'calvario31'
  }
  var accessToken = karate.callSingle('classpath:helpers/CreateToken.feature', config).authToken
  karate.configure('headers', { Authorization: 'Token ' + accessToken })

  return config;
}