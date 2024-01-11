import Vue from 'vue'
import App from './App.vue'

Vue.config.productionTip = false
console.log("main.js")
console.log("test")
console.log("commit")
console.log("web hook  ")
new Vue({
  render: h => h(App),
}).$mount('#app')
