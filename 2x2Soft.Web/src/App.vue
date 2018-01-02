<template>
  <div id="app">
    <myissues StartUrl="http://localhost/2x2CRM.mvc/Issue/"></myissues>
  </div>
</template>

<script>

import myissues from './MyIssues.vue'

export default {
  name: 'app',
  data () {
    // var MyIssues = null;
    // var Email = '';
    // var Persons = null;

    // fetch('http://localhost/2x2CRM.mvc/Issue/MyIssuesJson', {credentials: 'include', mode: 'cors'})
    //   .then(resp => resp.json())
    //   .then(data => {
    //     // MyIssues = data.Issues;
    //     Email = data.Email;
    //     // Persons = data.Persons;
    //   });


    return {
      msg: 'Welcome to Your Vue.js App'
    }
  },
  components: {
      myissues
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}

h1, h2 {
  font-weight: normal;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: inline-block;
  margin: 0 10px;
}

a {
  color: #42b983;
}
</style>
