<template>
  <div id='MyIssues'>
      <h2>My issues</h2>
      <div id="issue-list">
          <p>
              <button v-on:click="edit2(0)" class="btn btn-default">Create New Issue</button>

            <input inputmode="" type="text" placeholder="input filter" v-model="filter1"/>
            Страница <input inputmode="" type="text" placeholder="page" v-model="pageNo"/>

            <button v-on:click="prevPage" class="btn btn-default"><</button>
            <button v-on:click="nextPage" class="btn btn-default">></button>

            <!-- use the modal component, pass in the prop -->
            показано {{(pageNo-1) * pageRows + 1}} - {{pageNo * pageRows}}
            из {{rows}}
            страниц {{pages}}
          </p>
          <table>
              <tr>
                  <th  v-on:click="sortBy('OpDate')"  :class="{active: sortKey == 'OpDate' }" class="pointer">
                     Date
                      <span class="arrow" :class="sortOrders['OpDate'] > 0 ? 'asc' : 'dsc'"> </span>
                  </th>
                  <th  v-on:click="sortBy('ClientName')" :class="{active: sortKey == 'ClientName' }"  class="pointer">
                      Client
                      <span class="arrow" :class="sortOrders['ClientName'] > 0 ? 'asc' : 'dsc'"> </span>
                  </th>
                  <th>
                    First details
                  </th>
                  <th>
                    Actions
                  </th>
              </tr>

              <tr v-for="item in filtered_items" :key="item.Id">
                  <td>{{item.Date}}</td>
                  <td>{{item.ClientName}}</td>
                  <td>{{item.Name}}</td>
                  <td>
                      <span class="input-group-btn">
                          <button v-on:click="edit2(item.Id)" class="btn js-add  btn-default">Edit</button>
                          <button v-on:click="deleteIssue(item.Id)" class="btn js-add btn-default">Delete</button>
                      </span>
                  </td>
              </tr>
          </table>

          <issue v-if="showModal" v-on:close="showModal = false" :StartUrl="StartUrl" :Issues="issues" :Issue="currentIssue" :Persons="persons">
          </issue>
      </div>

</div>


  </div>
</template>

<script>

import issue from './Issue.vue'


export default {
        props: ['StartUrl'],
        data:function () {
          var sortOrders = {};
          sortOrders['OpDate'] = -1;
          sortOrders['ClientName'] = 1;

          var MyIssues = null;
          var Email = '';
          var Persons = null;
          var json;

          MyIssues = [{Date: '', ClientName: '', Name: ''}]
          Persons = [{Id: 0, Name: 'Брустинов'}]

          this.load();

          return {
            issues: [{Date: '', ClientName: '', Name: ''}],
            filter: "",
            pageNo: 1,
            pageRows: 50,
            pages: 0,
            rows: 0,
            showModal: false,
            currentId: 0,
            persons: [{Id: 0, Name: ''}],
            currentIssue: {},

            sortKey: '',
            sortOrders: sortOrders
          }
        },
        components: {
          issue
        },
        computed: {
          filtered_items: function() {
            var ret = [];
            var ret0 = [];
            var self = this;

            var sortKey = this.sortKey;
            var order = this.sortOrders[sortKey] || 1;

            ret0 = self.issues.slice();

            if (sortKey) {
              ret0 = self.issues.slice().sort(function(a, b) {
                return (a[sortKey] === b[sortKey] ? (
                  (a['OpDate'] === b['OpDate'] ? (
                    (a['ClientName'] === b['ClientName'] ? 0 : a['ClientName'] > b['ClientName'] ? 1 : -1) * self.sortOrders['ClientName'] || 1
                  ) : a['OpDate'] > b['OpDate'] ? 1 : -1) * self.sortOrders['OpDate'] || 1
                ) : a[sortKey] > b[sortKey] ? 1 : -1) * order;
              });
            }

            ret0 = ret0.filter(function(item) {
              return item.ClientName.toLowerCase().indexOf(self.filter.toLowerCase()) !== -1;
            });
            ret = ret0.filter(function(item, index) {
              return (index >= (0 + (self.pageNo - 1) * self.pageRows) && index < (self.pageNo) * self.pageRows);
            });

            this.pages = Math.ceil(ret0.length / this.pageRows);
            self.rows = ret0.length;
            return ret;
          },
          filter1: {
            get: function() {
              return this.filter;
            },
            set: function(newValue) {
              this.pageNo = 1;
              this.filter = newValue;
            }
          }
        },
        methods: {
          nextPage: function(event) {
            if (this.pageNo < this.pages) this.pageNo++;
          },
          prevPage: function(event) {
            if (this.pageNo > 1) this.pageNo--;
          },
          sortBy: function (key) {
            this.sortKey = key;
            this.sortOrders[key] = this.sortOrders[key] * -1;
          },
          load: function() {
            var self = this;
            // fetch('http://localhost/2x2CRM.mvc/Issue/MyIssuesJson', {credentials: 'include', mode: 'cors'})
            fetch(this.StartUrl + 'MyIssuesJson', {credentials: 'include', mode: 'cors'})
              .then(resp => resp.json())
              .then(data => {
                self.issues = data[2].Value;
                self.persons= data[1].Value;
              });

          },
          deleteIssue: function(i) {
            var result = confirm("Want to delete?");
            if (!result) return;
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "Delete/"+i, true);
            xhr.onreadystatechange = () => {
                if (xhr.readyState === 4 && xhr.status === 200) {
                  var removeIndex = this.issues.map(function(item) { return item.Id; }).indexOf(Number(i));
                  ~removeIndex && this.issues.splice(removeIndex, 1);
                }
            };
            xhr.send();
          },
          edit2: function(i) {

            if (i !== 0) {
              this.currentId = i;
              this.currentIssue = this.issues.find(el => el.Id === i);
              fetch( this.StartUrl + 'AddOrUpdate2/' + i, { credentials: 'include', mode: 'cors' })
                .then(resp => resp.json())
                .then(data => {
                  this.currentIssue.IssueDetails = data.IssueDetails;
                  this.currentIssue.IssueDetails.push({ Description: "", Hours: 0.00 });
                  this.currentIssue.Client = this.persons.find((el) => el.Id === data.ClientId);
                  this.currentIssue.Supporter = this.persons.find((el) => el.Id === data.SuppId);
                });
            } else {
              this.currentId = 0;
              //var tmpIssue = this.items.find(x => true);
              var tmpIssue = null;
              if (this.issues.length !== 0) {
                tmpIssue = this.issues.reduce((prev, current) => (prev.OpDate > current.OpDate) ? prev : current);
              }

              var suppId = 0;
              var supporter = null;
              var clientId    = 0;
              var client      = null;
              var supporterName = "";
              var clientName = "";

              if (tmpIssue !== null && tmpIssue !== undefined) {
                suppId    = tmpIssue.SuppId;
                supporter = tmpIssue.Supporter;
                supporterName = supporter!==null&&supporter!==undefined?supporter.Name:"";

                clientId    = tmpIssue.СlientId;
                client      = tmpIssue.Client;
                clientName = client!==null&&client!==undefined?client.Name:"";
              }

              this.currentIssue = {
                Id:0 
                ,OpDate:new Date()
                ,ClientId:clientId
                ,SuppId:suppId
                ,IssueDetails:[{Id:0, Description:""}]
                ,Client:client
                ,Supporter:supporter
                ,ClentName:clientName
                ,SupporterName:supporterName
                ,Date:("0"+new Date().getDate()).slice(-2) +"/"+ ("0"+(new Date().getMonth() + 1)).slice(-2) + "/" + new Date().getFullYear()
                ,Name:""
              }
            }
            this.showModal = true;
          }
        }

}
</script>

<style scoped>
    th {
    background-color: #42b983;
    color: rgba(255,255,255,0.66);
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    }

    .pointer {
    cursor: pointer;
    }


    td {
    background-color: #f9f9f9;
    }

    th, td {
    min-width: 120px;
    padding: 10px 20px;
    }

    td{
      text-align:left;
    }

    th.active {
    color: #fff;
    }

    th.active .arrow {
    opacity: 1;
    }

    .arrow {
    display: inline-block;
    vertical-align: middle;
    width: 0;
    height: 0;
    margin-left: 5px;
    opacity: 0.66;
    }

    .arrow.asc {
    border-left: 4px solid transparent;
    border-right: 4px solid transparent;
    border-bottom: 4px solid #fff;
    }

    .arrow.dsc {
    border-left: 4px solid transparent;
    border-right: 4px solid transparent;
    border-top: 4px solid #fff;
    }

</style>
