﻿<!-- template for the modal component -->
<template id="modal-template">
    <transition name="modal">
        <div class="modal-mask">
            <div class="modal-wrapper">
                <div class="modal-container">

                    <div class="modal-header">
                        <slot name="header">
                            Issue
                        </slot>
                    </div>

                    <div class="modal-body">
                        <slot name="body">

                            <div class="form-group row">
                                <label class="control-label col-md-1" for="OpDate">OpDate</label>
                                <div class="col-md-9">
                                    <input id="Date" name="Date" v-model:value="Issue.Date" class="form-control" />
                                </div>
                            </div>


                            <div class="form-group row">
                                <label class="control-label col-md-1" for="Client">Client</label>
                                <div class="col-md-9">
                                    <v-select :debounce="1000"
                                              :on-search="getClientOptions"
                                              :on-change="getClientIdCallback"
                                              :options="optionsClient"
                                              :value=Issue.Client
                                              placeholder="Search client..."
                                              label="Name">
                                    </v-select>
                                </div>
                            </div>


                            <div class="form-group row">
                                <label class="control-label col-md-1" for="Client">Supporter</label>
                                <div class="col-md-9">
                                    <v-select :debounce="1000"
                                              :on-search="getSuppOptions"
                                              :on-change="getSuppIdCallback"
                                              :options="optionsSupp"
                                              :value=Issue.Supporter
                                              placeholder="Search supporter..."
                                              label="Name">
                                    </v-select>
                                </div>
                            </div>

                            <tr v-for="descr in Issue.IssueDetails">
                                <td>
                                    <textarea cols="100" v-on:keyup="onChange" style="max-width: 748px; width: 748px; max-height: 80px; height: 80px; resize: none;" maxlength="255" v-model="descr.Description" class="form-control" name="IssueDetails[]" placeholder="Enter task"></textarea>
                                </td>
                                <td style="vertical-align: top;">
                                    <input type="number" v-model="descr.Hours" class="form-control" />
                                </td>
                            </tr>
                        </slot>
                    </div>

                    <div class="modal-footer">
                        <slot name="footer">
                            <button class="modal-default-button" v-on:click="$emit('close');">Close</button>
                            <button class="modal-default-button" v-on:click="onSave">Save </button>
                        </slot>
                    </div>
                </div>
            </div>
        </div>
    </transition>
</template>

<script>
    module.exports = {
        template: '#modal-template',
        props: ['Id', 'Issue', 'Persons'],
        data: function () {
            return {
                OpDate: this.Issue.Date,
                ClientId: this.Issue.ClientId,
                SuppId: this.Issue.SuppId,
                IssueDetails: this.Issue.IssueDetails,
                Supporter: { Id: this.Issue.SuppId, Name: this.Issue.SupporterName },
                optionsSupp: this.Persons,
                optionsClient: this.Persons,
                items: this.Persons,
                Client: { Id: this.ClientId, Name: "not defined" }
            }
        },
        methods: {
            onChange(val) {
                //console.log("onChange");
                if (this.Issue.IssueDetails[this.Issue.IssueDetails.length - 1].Description.length) {
                    this.Issue.IssueDetails.push({ Description: "", Hours: 0.00 });
                }
            },
            getClientOptions(search, loading) {
                loading(true);
                this.options = this.items.filter(function (item) { return item.Name.toLowerCase().indexOf(search.toLowerCase()) !== -1; });
                loading(false);
            },
            getClientIdCallback(val) {
                this.ClientId = val.Id;
                //console.dir(JSON.stringify(val));
            },
            getSuppOptions(search, loading) {
                loading(true);
                this.options = this.items.filter(function (item) { return item.Name.toLowerCase().indexOf(search.toLowerCase()) !== -1; });
                loading(false);
            },
            getSuppIdCallback(val) {
                this.SuppId = val.Id;
                //console.dir(JSON.stringify(val));
            },
            onSave() {
                this.Issue.ClientName = this.items.find((el) => el.Id === this.ClientId).Name;
                this.Issue.Client.Name = this.Issue.ClientName;
                this.Issue.Client.Id = this.Issue.ClientId;
                this.Issue.Name = this.Issue.IssueDetails[0].Description;


                this.Issue.IssueDetails.forEach((item) => item.Hours = Number(item.Hours));

                var d = this.Issue.Date;
                d = d.slice(6, 10) + "-" + d.slice(3, 5) + "-" + d.slice(0, 2);

                var sendModel = {
                    Id: this.Id,
                    OpDate: d,
                    ClientId: this.ClientId,
                    SuppId: this.SuppId,
                    IssueDetails: this.Issue.IssueDetails.filter(function (item) { return item.Description.trim() !== ""; })
                }

                var xhr = new XMLHttpRequest();
                xhr.open("POST", "/Issue/AddOrUpdate", true);
                xhr.setRequestHeader("Content-type", "application/json; charset=utf-8");
                xhr.onreadystatechange = () => {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        this.Id = xhr.responseText;
                        //window.history.pushState('/Issue/AddOrUpdate', '/Issue/AddOrUpdate', '/Issue/AddOrUpdate/'+this.Id);
                        //console.log(xhr.responseText);
                    }
                };
                var data = JSON.stringify(sendModel);
                xhr.send(data);
            }
        }
    };

</script>



<style type="text/css">
    .modal-mask {
        position: fixed;
        z-index: 9998;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, .5);
        display: table;
        transition: opacity .3s ease;
    }

    .modal-wrapper {
        display: table-cell;
        vertical-align: middle;
    }

    .modal-container {
        width: 1200px;
        margin: 0px auto;
        padding: 20px 30px;
        background-color: #fff;
        border-radius: 2px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, .33);
        transition: all .3s ease;
        font-family: Helvetica, Arial, sans-serif;
    }

    .modal-header h3 {
        margin-top: 0;
        color: #42b983;
    }

    .modal-body {
        margin: 20px 0;
    }

    .modal-default-button {
        float: right;
    }

    /*
     * The following styles are auto-applied to elements with
     * transition="modal" when their visibility is toggled
     * by Vue.js.
     *
     * You can easily play with the modal transition by editing
     * these styles.
     */

    .modal-enter {
        opacity: 0;
    }

    .modal-leave-active {
        opacity: 0;
    }

        .modal-enter .modal-container,
        .modal-leave-active .modal-container {
            -webkit-transform: scale(1.1);
            transform: scale(1.1);
        }
</style>

