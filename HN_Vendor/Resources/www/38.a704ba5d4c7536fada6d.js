(window.webpackJsonp=window.webpackJsonp||[]).push([[38],{"Ja+p":function(l,n,e){"use strict";e.d(n,"a",function(){return u});var t=e("ZZ/e"),o=e("CcnG"),u=function(){function l(l){this.navCtrl=l}return l.prototype.push=function(l,n){void 0===n&&(n={}),this.data=n,this.navCtrl.navigateForward("/"+(l||""))},l.prototype.pop=function(l){this.navCtrl.navigateBack("/"+(l||""))},l.prototype.get=function(l){return this.data[l]},l.ngInjectableDef=o.defineInjectable({factory:function(){return new l(o.inject(t.NavController))},token:l,providedIn:"root"}),l}()},nu5N:function(l,n,e){"use strict";e.r(n);var t=e("CcnG"),o=e("mrSG"),u=e("fLog"),a=e("A6Y8"),i=e("ZZ/e"),r=e("i7gp"),s=e("Ja+p"),c=e("6mc2"),d=e("KH1z"),m=e("ajt+"),p=e("sJLo"),_=function(){function l(l,n,e,t,o,u,a){var i=this;this.taskData=l,this.nav=n,this.tools=e,this.events=t,this.db=o,this.modalCtrl=u,this.sync=a,this.paramValues=[],this.project=null,this.currPositionItem=null,this.currRoomItem=null,this.standNames=[],this.selectedQueItems=[],this.levelOptions=[],this.currCompositionItem="",this.hasCreated=!1,this.navParams={checkup_type:"",checkup_id:"",backTo:"",plan_mid:"",curr_problem:null,fromType:"0"},this.que_data={project_id:this.sync.getProject().id,position_id:"",position_desc:"",plan_mid:"",images:[],qaitem_id:"",problem_name:"",level_id:"",level_name:"",checkup_id:"",checkup_type:"",istand_day:"",iannex_problem:"",oper_man:null,auth_man:null,roomid:"",unitid:"",floor:"",object_id:"",object_name:"",object_type:""},this.project=Object.assign({},this.sync.getProject()),this.events.subscribe("qa.selected",function(l){console.log(l),i.populateData(l)}),this.navParams=Object.assign({},this.nav.data),console.log(this.navParams),this.que_data.checkup_id=this.navParams.checkup_id,this.que_data.checkup_type=this.navParams.checkup_type,this.navParams.curr_problem&&this.populateData(this.navParams.curr_problem)}return l.prototype.ngOnInit=function(){},l.prototype.populateData=function(l){this.currPositionItem=l,l?(this.currRoomItem=Object.assign({},l.roomItem),this.que_data.istand_day=l.istand_day,this.que_data.position_id=l.pro_position_id,this.que_data.qaitem_id=l.qaitem_id,this.que_data.plan_mid=l.plan_mid||"",this.que_data.roomid=l.roomItem.roomid,this.que_data.unitid=l.roomItem.unitid,this.que_data.floor=l.roomItem.floor,this.que_data.object_id=l.roomItem.object_id,this.que_data.object_name=l.roomItem.object_name||l.roomItem.object_name1,this.que_data.object_type=l.roomItem.object_type,this.standNames=l.quest_info?l.quest_info.split("||"):[],this.standNames=this.standNames.filter(function(l){return l.length>0&&"NULL"!==l})):(this.currRoomItem=null,this.que_data.istand_day="",this.que_data.position_id="",this.que_data.qaitem_id="",this.que_data.plan_mid="",this.que_data.roomid="",this.que_data.unitid="",this.que_data.floor="",this.que_data.object_id="",this.que_data.object_name="",this.que_data.object_type="",this.standNames=[]),console.log(this.que_data)},l.prototype.ngOnDestroy=function(){this.events.publish("que.notify",this.hasCreated?"1":"0")},l.prototype.formatQueNames=function(){return this.currRoomItem?this.currRoomItem.object_name1:"\u8bf7\u9009\u62e9"},l.prototype.formatQueNames2=function(){return this.currPositionItem?this.currPositionItem.position_name?this.currPositionItem.position_name+" / "+this.currPositionItem.qatype_name+" / "+this.currPositionItem.qaitem_name:this.currPositionItem.qatype_name&&this.currPositionItem.qaitem_name?this.currPositionItem.qatype_name+" / "+this.currPositionItem.qaitem_name:"\u8bf7\u9009\u62e9":"\u8bf7\u9009\u62e9"},l.prototype.selectQue=function(l){var n="["+l+"]",e=this.que_data.problem_name.replace(this.currCompositionItem,"");-1===this.selectedQueItems.indexOf(n)?this.selectedQueItems.push(n):this.selectedQueItems.splice(this.selectedQueItems.indexOf(n),1),this.currCompositionItem=this.selectedQueItems.join(""),this.que_data.problem_name=this.currCompositionItem+e},l.prototype.selectCheckType=function(){var l=this;this.navParams.checkup_id||this.taskData.getCheckTypes(function(n){var e=[];n.forEach(function(l){e.push(l.dic_name+"|"+l.dic_value)}),l.showCheckTypeSelect(e)})},l.prototype.selectLevel=function(){var l=this;this.db.initDB().then(function(){l.db.select("que_level_list",[],{},function(n){var e=[];n.forEach(function(l){e.push(l.dic_name+"|"+l.dic_value)}),l.showLevelModel(e)})})},l.prototype.showLevelModel=function(l){return o.__awaiter(this,void 0,void 0,function(){var n,e=this;return o.__generator(this,function(t){switch(t.label){case 0:return[4,this.modalCtrl.create({component:r.a,componentProps:{title:"\u9009\u62e9\u4e25\u91cd\u7a0b\u5ea6",data:l}})];case 1:return(n=t.sent()).onDidDismiss().then(function(l){l.data&&(e.que_data.level_name=l.data.label,e.que_data.level_id=l.data.value)}),n.present(),[2]}})})},l.prototype.showCheckTypeSelect=function(l){return o.__awaiter(this,void 0,void 0,function(){var n,e=this;return o.__generator(this,function(t){switch(t.label){case 0:return[4,this.modalCtrl.create({component:r.a,componentProps:{title:"\u9009\u62e9\u68c0\u67e5\u7c7b\u578b",data:l}})];case 1:return(n=t.sent()).onDidDismiss().then(function(l){l.data&&l.data.value!==e.que_data.checkup_id&&(e.populateData(null),e.que_data.checkup_type=l.data.label,e.que_data.checkup_id=l.data.value)}),n.present(),[2]}})})},l.prototype.selectMan1=function(){this.showModal("oper_man")},l.prototype.selectMan2=function(){this.showModal("auth_man")},l.prototype.showModal=function(l){return o.__awaiter(this,void 0,void 0,function(){var n,e=this;return o.__generator(this,function(t){switch(t.label){case 0:return[4,this.modalCtrl.create({component:d.a,componentProps:{title:"\u8bf7\u9009\u62e9",type:1,dataType:"0"}})];case 1:return(n=t.sent()).onDidDismiss().then(function(n){n.data&&(e.que_data[l]=n.data)}),n.present(),[2]}})})},l.prototype.selectPositionItem=function(){this.navParams.curr_problem||(this.que_data.checkup_id?this.nav.push("check-place-home",{plan_mid:this.navParams.plan_mid||"",checkup_id:this.que_data.checkup_id||"",fromType:this.navParams.fromType||"0",func_type:"1"}):this.tools.showToast("\u8bf7\u9009\u62e9\u68c0\u67e5\u7c7b\u578b"))},l.prototype.selectProblemItem=function(){if(!this.navParams.curr_problem||!this.navParams.curr_problem.position_name)if(this.currRoomItem){var l=Object.assign({},this.currRoomItem);l.checkup_id=this.que_data.checkup_id,l.fromType=this.navParams.fromType||"0",this.nav.push("60"===this.que_data.checkup_id||"70"===this.que_data.checkup_id?"qa-item-list":"qa-item-list2",l)}else this.tools.showToast("\u8bf7\u9009\u62e9\u95ee\u9898\u90e8\u4f4d")},l.prototype.addDay=function(l){var n=this.que_data.istand_day.replace("NULL","0");n=n||"0",n=parseInt(n),(n+=l)<0&&(n=0),this.que_data.istand_day=n.toString()},l.prototype.createQue=function(){var l=this;if(0!==this.que_data.images.length)if(this.que_data.checkup_id)if(this.currRoomItem)if(this.currPositionItem)if(this.que_data.problem_name)if(this.que_data.level_id)if(this.que_data.oper_man)if(this.que_data.auth_man){var n=this.que_data.auth_man.unitType,e=this.que_data.oper_man,t=this.que_data.auth_man,o="",u="";"2"===t.type?(o=t.id,u=""):"3"===t.type&&(u=t.id,o="");var a="",i="";"2"===e.type?(a=e.id,i=""):"3"===e.type&&(i=e.id,a="");var r=","+(this.que_data.roomid||"")+","+(this.que_data.unitid||"")+","+(this.que_data.floor||"")+","+(this.que_data.object_id||"")+","+(this.que_data.position_id||"")+","+(this.que_data.checkup_id||"")+","+(this.que_data.qaitem_id||"")+","+(this.que_data.level_id||"")+","+(this.que_data.istand_day||"")+","+p.a.getManID()+","+a+","+i+","+o+","+u+","+p.a.getManID(),s={problem_id:"",plan_mid:this.que_data.plan_mid||this.navParams.plan_mid||"",project_id:this.que_data.project_id,object_type:this.que_data.object_type,object_name:this.que_data.object_name,position_desc:this.que_data.position_desc,problem_name:this.que_data.problem_name,unittype:n.dic_name,from_type:"APP",comp_fields:"ContractID,RoomID,UnitID,Floor,Object_ID,position_id,checkup_id,qaitem_id,level_id,istand_day,Mange_ManID,correct_manID,correct_roleID,Accept_ManID,Accept_RoleID,Create_ID",comp_values:r.replace(/NULL/g,""),annexes:this.que_data.images.join("|")};this.db.initDB().then(function(){l.db.insert("add_que",[s],function(n){l.tools.showToast("\u4fdd\u5b58\u6210\u529f"),l.hasCreated=!0,l.standNames=[],l.selectedQueItems=[],l.currCompositionItem=null,l.currPositionItem=null,l.que_data={project_id:l.sync.getProject().id,position_id:"",position_desc:"",plan_mid:"",images:[],qaitem_id:"",problem_name:"",level_id:"",level_name:"",checkup_id:l.que_data.checkup_id,checkup_type:l.que_data.checkup_type,istand_day:"",iannex_problem:"",oper_man:null,auth_man:l.que_data.auth_man,roomid:"",unitid:"",floor:"",object_id:"",object_name:"",object_type:""},console.log(l.que_data),l.navParams.backTo&&"home"!==l.navParams.backTo&&l.nav.pop(l.navParams.backTo)})})}else this.tools.showToast("\u590d\u6838\u4eba\u4e0d\u80fd\u4e3a\u7a7a");else this.tools.showToast("\u6574\u6539\u4eba\u4e0d\u80fd\u4e3a\u7a7a");else this.tools.showToast("\u4e25\u91cd\u7a0b\u5ea6\u4e0d\u80fd\u4e3a\u7a7a");else this.tools.showToast("\u95ee\u9898\u8bf4\u660e\u4e0d\u80fd\u4e3a\u7a7a");else this.tools.showToast("\u68c0\u67e5\u9879\u4e0d\u80fd\u4e3a\u7a7a");else this.tools.showToast("\u95ee\u9898\u90e8\u4f4d\u4e0d\u80fd\u4e3a\u7a7a");else this.tools.showToast("\u68c0\u67e5\u7c7b\u578b\u4e0d\u80fd\u4e3a\u7a7a");else this.tools.showToast("\u81f3\u5c11\u9700\u8981\u4e0a\u4f201\u4e2a\u9644\u4ef6")},l.prototype.reset=function(l){void 0===l&&(l=!1),this.hasCreated=l,this.standNames=[],this.selectedQueItems=[],this.currCompositionItem=null,this.currPositionItem=null,this.currRoomItem=null,this.que_data={project_id:this.sync.getProject().id,position_id:"",position_desc:"",plan_mid:"",images:[],qaitem_id:"",problem_name:"",level_id:"",level_name:"",checkup_id:"",checkup_type:"",istand_day:"",iannex_problem:"",oper_man:null,auth_man:null,roomid:"",unitid:"",floor:"",object_id:"",object_name:"",object_type:""}},l.prototype.fileSelected=function(l){this.que_data.images=l},l}(),h=function(){return function(){}}(),f=e("pMnS"),g=e("niVF"),v=e("NAMV"),C=e("4PO/"),b=e("oBZk"),q=e("ESoL"),I=e("R3V5"),y=e("gIcY"),P=e("Ip0R"),k=t["\u0275crt"]({encapsulation:0,styles:[[".stand-names[_ngcontent-%COMP%]   .que-item[_ngcontent-%COMP%]{display:inline-block;padding:10px 15px;font-size:12px;background:#f2f2f2;color:#999;margin:5px;border-radius:2px}.stand-names[_ngcontent-%COMP%]   .que-item.active[_ngcontent-%COMP%]{background:#e75a16;color:#fff}.form-group[_ngcontent-%COMP%]{display:flex;padding:15px;border-bottom:.55px solid #f2f2f2;align-items:center}.form-group.vertical-layout[_ngcontent-%COMP%]{display:block}.form-group.vertical-layout[_ngcontent-%COMP%]   .form-label[_ngcontent-%COMP%]{width:100%}.form-group.vertical-layout[_ngcontent-%COMP%]   .form-control[_ngcontent-%COMP%]{width:100%;text-align:left;margin-top:10px}.form-group[_ngcontent-%COMP%]   .form-label[_ngcontent-%COMP%]{flex:0 0 120px;font-size:14px;color:#333}.form-group[_ngcontent-%COMP%]   .form-control[_ngcontent-%COMP%]{flex:1;color:#999;font-size:14px;text-align:right}.form-group[_ngcontent-%COMP%]   .form-control[_ngcontent-%COMP%]   ion-icon[_ngcontent-%COMP%]{vertical-align:-1px}.form-group[_ngcontent-%COMP%]   .select-val[_ngcontent-%COMP%]{display:inline-block;width:calc(100% - 30px);margin-right:5px}.incr-control[_ngcontent-%COMP%]{display:inline-block;border:.55px solid #ccc;border-radius:3px}.incr-control[_ngcontent-%COMP%]   .left[_ngcontent-%COMP%], .incr-control[_ngcontent-%COMP%]   .right[_ngcontent-%COMP%], .incr-control[_ngcontent-%COMP%]   .val[_ngcontent-%COMP%]{display:inline-block;vertical-align:middle;font-size:14px}.incr-control[_ngcontent-%COMP%]   .left[_ngcontent-%COMP%], .incr-control[_ngcontent-%COMP%]   .right[_ngcontent-%COMP%]{width:32px;height:32px;text-align:center;line-height:32px;vertical-align:middle}.incr-control[_ngcontent-%COMP%]   .left[_ngcontent-%COMP%]   ion-icon[_ngcontent-%COMP%], .incr-control[_ngcontent-%COMP%]   .right[_ngcontent-%COMP%]   ion-icon[_ngcontent-%COMP%]{font-size:22px;vertical-align:-7px;line-height:22px}.incr-control[_ngcontent-%COMP%]   .val[_ngcontent-%COMP%]{height:32px;line-height:32px;min-width:50px;text-align:center;padding:0 5px;border-left:.55px solid #ccc;border-right:.55px solid #ccc}.splitor[_ngcontent-%COMP%]{height:5px;background:#f8f8f8}.required[_ngcontent-%COMP%]{font-size:14px;color:#e75a16;padding-right:3px}"]],data:{}});function M(l){return t["\u0275vid"](0,[(l()(),t["\u0275eld"](0,0,null,null,1,"span",[["class","que-item"],["tappable",""]],[[2,"active",null]],[[null,"click"]],function(l,n,e){var t=!0;return"click"===n&&(t=!1!==l.component.selectQue(l.context.$implicit)&&t),t},null,null)),(l()(),t["\u0275ted"](1,null,["",""]))],null,function(l,n){l(n,0,0,-1!==n.component.selectedQueItems.indexOf("["+n.context.$implicit+"]")),l(n,1,0,n.context.$implicit)})}function R(l){return t["\u0275vid"](0,[(l()(),t["\u0275eld"](0,0,null,null,11,"ion-header",[["no-border",""]],null,null,null,b.T,b.n)),t["\u0275did"](1,49152,null,0,i.IonHeader,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],null,null),(l()(),t["\u0275eld"](2,0,null,0,9,"ion-toolbar",[["color","primary"]],null,null,null,b.kb,b.E)),t["\u0275did"](3,49152,null,0,i.IonToolbar,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],{color:[0,"color"]},null),(l()(),t["\u0275eld"](4,0,null,0,4,"ion-buttons",[["slot","start"]],null,null,null,b.J,b.d)),t["\u0275did"](5,49152,null,0,i.IonButtons,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],null,null),(l()(),t["\u0275eld"](6,0,null,0,2,"ion-back-button",[["default-href","backTo"]],null,[[null,"click"]],function(l,n,e){var o=!0;return"click"===n&&(o=!1!==t["\u0275nov"](l,8).onClick(e)&&o),o},b.H,b.b)),t["\u0275did"](7,49152,null,0,i.IonBackButton,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],null,null),t["\u0275did"](8,16384,null,0,i.IonBackButtonDelegate,[[2,i.IonRouterOutlet],i.NavController],null,null),(l()(),t["\u0275eld"](9,0,null,0,2,"ion-title",[],null,null,null,b.jb,b.D)),t["\u0275did"](10,49152,null,0,i.IonTitle,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],null,null),(l()(),t["\u0275ted"](-1,0,["\u95ee\u9898\u63d0\u4ea4"])),(l()(),t["\u0275eld"](12,0,null,null,119,"ion-content",[["style","display: flex;"]],null,null,null,b.P,b.j)),t["\u0275did"](13,49152,null,0,i.IonContent,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],null,null),(l()(),t["\u0275eld"](14,0,null,0,117,"div",[["class","form-box"]],null,null,null,null,null)),(l()(),t["\u0275eld"](15,0,null,null,4,"div",[["class","form-group"]],null,null,null,null,null)),(l()(),t["\u0275eld"](16,0,null,null,1,"div",[["class","form-label"]],null,null,null,null,null)),(l()(),t["\u0275ted"](-1,null,[" \u6240\u5c5e\u9879\u76ee "])),(l()(),t["\u0275eld"](18,0,null,null,1,"div",[["class","form-control"]],null,null,null,null,null)),(l()(),t["\u0275ted"](19,null,[" "," "])),(l()(),t["\u0275eld"](20,0,null,null,7,"div",[["class","form-group vertical-layout"]],null,null,null,null,null)),(l()(),t["\u0275eld"](21,0,null,null,3,"div",[["class","form-label"]],null,null,null,null,null)),(l()(),t["\u0275eld"](22,0,null,null,1,"span",[["class","required"]],null,null,null,null,null)),(l()(),t["\u0275ted"](-1,null,["*"])),(l()(),t["\u0275ted"](-1,null,["\u95ee\u9898\u90e8\u4f4d\u9644\u4ef6 "])),(l()(),t["\u0275eld"](25,0,null,null,2,"div",[["class","form-control"]],null,null,null,null,null)),(l()(),t["\u0275eld"](26,0,null,null,1,"app-image-uploader",[],null,[[null,"fileSelected"]],function(l,n,e){var t=!0;return"fileSelected"===n&&(t=!1!==l.component.fileSelected(e)&&t),t},q.b,q.a)),t["\u0275did"](27,114688,null,0,I.a,[i.ModalController,c.a,i.AlertController],{images:[0,"images"]},{fileSelected:"fileSelected"}),(l()(),t["\u0275eld"](28,0,null,null,10,"div",[["class","form-group"]],null,null,null,null,null)),(l()(),t["\u0275eld"](29,0,null,null,1,"div",[["class","form-label"]],null,null,null,null,null)),(l()(),t["\u0275ted"](-1,null,[" \u95ee\u9898\u90e8\u4f4d\u63cf\u8ff0 "])),(l()(),t["\u0275eld"](31,0,null,null,7,"div",[["class","form-control"]],null,null,null,null,null)),(l()(),t["\u0275eld"](32,0,null,null,6,"ion-input",[["placeholder","\u8bf7\u8f93\u5165\u90e8\u4f4d\u63cf\u8ff0"]],[[2,"ng-untouched",null],[2,"ng-touched",null],[2,"ng-pristine",null],[2,"ng-dirty",null],[2,"ng-valid",null],[2,"ng-invalid",null],[2,"ng-pending",null]],[[null,"ngModelChange"],[null,"ionBlur"],[null,"ionChange"]],function(l,n,e){var o=!0,u=l.component;return"ionBlur"===n&&(o=!1!==t["\u0275nov"](l,33)._handleBlurEvent(e.target)&&o),"ionChange"===n&&(o=!1!==t["\u0275nov"](l,33)._handleInputEvent(e.target)&&o),"ngModelChange"===n&&(o=!1!==(u.que_data.position_desc=e)&&o),o},b.X,b.r)),t["\u0275did"](33,16384,null,0,i.TextValueAccessor,[t.ElementRef],null,null),t["\u0275prd"](1024,null,y.NG_VALUE_ACCESSOR,function(l){return[l]},[i.TextValueAccessor]),t["\u0275did"](35,671744,null,0,y.NgModel,[[8,null],[8,null],[8,null],[6,y.NG_VALUE_ACCESSOR]],{model:[0,"model"]},{update:"ngModelChange"}),t["\u0275prd"](2048,null,y.NgControl,null,[y.NgModel]),t["\u0275did"](37,16384,null,0,y.NgControlStatus,[[4,y.NgControl]],null,null),t["\u0275did"](38,49152,null,0,i.IonInput,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],{placeholder:[0,"placeholder"]},null),(l()(),t["\u0275eld"](39,0,null,null,0,"div",[["class","splitor"]],null,null,null,null,null)),(l()(),t["\u0275eld"](40,0,null,null,9,"div",[["class","form-group"]],null,null,null,null,null)),(l()(),t["\u0275eld"](41,0,null,null,3,"div",[["class","form-label"]],null,null,null,null,null)),(l()(),t["\u0275eld"](42,0,null,null,1,"span",[["class","required"]],null,null,null,null,null)),(l()(),t["\u0275ted"](-1,null,["*"])),(l()(),t["\u0275ted"](-1,null,["\u68c0\u67e5\u7c7b\u578b "])),(l()(),t["\u0275eld"](45,0,null,null,4,"div",[["class","form-control"],["tappable",""]],null,[[null,"click"]],function(l,n,e){var t=!0;return"click"===n&&(t=!1!==l.component.selectCheckType()&&t),t},null,null)),(l()(),t["\u0275eld"](46,0,null,null,1,"span",[["class","select-val"]],null,null,null,null,null)),(l()(),t["\u0275ted"](47,null,["",""])),(l()(),t["\u0275eld"](48,0,null,null,1,"ion-icon",[["name","arrow-forward"]],null,null,null,b.U,b.o)),t["\u0275did"](49,49152,null,0,i.IonIcon,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],{name:[0,"name"]},null),(l()(),t["\u0275eld"](50,0,null,null,9,"div",[["class","form-group"]],null,null,null,null,null)),(l()(),t["\u0275eld"](51,0,null,null,3,"div",[["class","form-label"]],null,null,null,null,null)),(l()(),t["\u0275eld"](52,0,null,null,1,"span",[["class","required"]],null,null,null,null,null)),(l()(),t["\u0275ted"](-1,null,["*"])),(l()(),t["\u0275ted"](-1,null,["\u95ee\u9898\u90e8\u4f4d "])),(l()(),t["\u0275eld"](55,0,null,null,4,"div",[["class","form-control"],["tappable",""]],null,[[null,"click"]],function(l,n,e){var t=!0;return"click"===n&&(t=!1!==l.component.selectPositionItem()&&t),t},null,null)),(l()(),t["\u0275eld"](56,0,null,null,1,"span",[["class","select-val"]],null,null,null,null,null)),(l()(),t["\u0275ted"](57,null,["",""])),(l()(),t["\u0275eld"](58,0,null,null,1,"ion-icon",[["name","arrow-forward"]],null,null,null,b.U,b.o)),t["\u0275did"](59,49152,null,0,i.IonIcon,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],{name:[0,"name"]},null),(l()(),t["\u0275eld"](60,0,null,null,9,"div",[["class","form-group"]],null,null,null,null,null)),(l()(),t["\u0275eld"](61,0,null,null,3,"div",[["class","form-label"]],null,null,null,null,null)),(l()(),t["\u0275eld"](62,0,null,null,1,"span",[["class","required"]],null,null,null,null,null)),(l()(),t["\u0275ted"](-1,null,["*"])),(l()(),t["\u0275ted"](-1,null,["\u68c0\u67e5\u9879 "])),(l()(),t["\u0275eld"](65,0,null,null,4,"div",[["class","form-control"],["tappable",""]],null,[[null,"click"]],function(l,n,e){var t=!0;return"click"===n&&(t=!1!==l.component.selectProblemItem()&&t),t},null,null)),(l()(),t["\u0275eld"](66,0,null,null,1,"span",[["class","select-val"]],null,null,null,null,null)),(l()(),t["\u0275ted"](67,null,["",""])),(l()(),t["\u0275eld"](68,0,null,null,1,"ion-icon",[["name","arrow-forward"]],null,null,null,b.U,b.o)),t["\u0275did"](69,49152,null,0,i.IonIcon,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],{name:[0,"name"]},null),(l()(),t["\u0275eld"](70,0,null,null,15,"div",[["class","form-group vertical-layout"]],null,null,null,null,null)),(l()(),t["\u0275eld"](71,0,null,null,3,"div",[["class","form-label"]],null,null,null,null,null)),(l()(),t["\u0275eld"](72,0,null,null,1,"span",[["class","required"]],null,null,null,null,null)),(l()(),t["\u0275ted"](-1,null,["*"])),(l()(),t["\u0275ted"](-1,null,["\u95ee\u9898\u8bf4\u660e "])),(l()(),t["\u0275eld"](75,0,null,null,10,"div",[["class","form-control"]],null,null,null,null,null)),(l()(),t["\u0275eld"](76,0,null,null,6,"ion-textarea",[["placeholder","\u8bf7\u8f93\u5165\u95ee\u9898\u8bf4\u660e"],["rows","3"]],[[2,"ng-untouched",null],[2,"ng-touched",null],[2,"ng-pristine",null],[2,"ng-dirty",null],[2,"ng-valid",null],[2,"ng-invalid",null],[2,"ng-pending",null]],[[null,"ngModelChange"],[null,"ionBlur"],[null,"ionChange"]],function(l,n,e){var o=!0,u=l.component;return"ionBlur"===n&&(o=!1!==t["\u0275nov"](l,77)._handleBlurEvent(e.target)&&o),"ionChange"===n&&(o=!1!==t["\u0275nov"](l,77)._handleInputEvent(e.target)&&o),"ngModelChange"===n&&(o=!1!==(u.que_data.problem_name=e)&&o),o},b.ib,b.C)),t["\u0275did"](77,16384,null,0,i.TextValueAccessor,[t.ElementRef],null,null),t["\u0275prd"](1024,null,y.NG_VALUE_ACCESSOR,function(l){return[l]},[i.TextValueAccessor]),t["\u0275did"](79,671744,null,0,y.NgModel,[[8,null],[8,null],[8,null],[6,y.NG_VALUE_ACCESSOR]],{model:[0,"model"]},{update:"ngModelChange"}),t["\u0275prd"](2048,null,y.NgControl,null,[y.NgModel]),t["\u0275did"](81,16384,null,0,y.NgControlStatus,[[4,y.NgControl]],null,null),t["\u0275did"](82,49152,null,0,i.IonTextarea,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],{placeholder:[0,"placeholder"],rows:[1,"rows"]},null),(l()(),t["\u0275eld"](83,0,null,null,2,"div",[["class","stand-names"]],null,null,null,null,null)),(l()(),t["\u0275and"](16777216,null,null,1,null,M)),t["\u0275did"](85,278528,null,0,P.NgForOf,[t.ViewContainerRef,t.TemplateRef,t.IterableDiffers],{ngForOf:[0,"ngForOf"]},null),(l()(),t["\u0275eld"](86,0,null,null,0,"div",[["class","splitor"]],null,null,null,null,null)),(l()(),t["\u0275eld"](87,0,null,null,9,"div",[["class","form-group"]],null,null,null,null,null)),(l()(),t["\u0275eld"](88,0,null,null,3,"div",[["class","form-label"]],null,null,null,null,null)),(l()(),t["\u0275eld"](89,0,null,null,1,"span",[["class","required"]],null,null,null,null,null)),(l()(),t["\u0275ted"](-1,null,["*"])),(l()(),t["\u0275ted"](-1,null,["\u4e25\u91cd\u7a0b\u5ea6 "])),(l()(),t["\u0275eld"](92,0,null,null,4,"div",[["class","form-control"],["tappable",""]],null,[[null,"click"]],function(l,n,e){var t=!0;return"click"===n&&(t=!1!==l.component.selectLevel()&&t),t},null,null)),(l()(),t["\u0275eld"](93,0,null,null,1,"span",[["class","select-val"]],null,null,null,null,null)),(l()(),t["\u0275ted"](94,null,["",""])),(l()(),t["\u0275eld"](95,0,null,null,1,"ion-icon",[["name","arrow-forward"]],null,null,null,b.U,b.o)),t["\u0275did"](96,49152,null,0,i.IonIcon,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],{name:[0,"name"]},null),(l()(),t["\u0275eld"](97,0,null,null,14,"div",[["class","form-group"]],null,null,null,null,null)),(l()(),t["\u0275eld"](98,0,null,null,3,"div",[["class","form-label"]],null,null,null,null,null)),(l()(),t["\u0275eld"](99,0,null,null,1,"span",[["class","required"]],null,null,null,null,null)),(l()(),t["\u0275ted"](-1,null,["*"])),(l()(),t["\u0275ted"](-1,null,["\u6574\u6539\u671f\u9650(\u5929) "])),(l()(),t["\u0275eld"](102,0,null,null,9,"div",[["class","form-control"]],null,null,null,null,null)),(l()(),t["\u0275eld"](103,0,null,null,8,"span",[["class","incr-control"]],null,null,null,null,null)),(l()(),t["\u0275eld"](104,0,null,null,2,"span",[["class","left"],["tappable",""]],null,[[null,"click"]],function(l,n,e){var t=!0;return"click"===n&&(t=!1!==l.component.addDay(-1)&&t),t},null,null)),(l()(),t["\u0275eld"](105,0,null,null,1,"ion-icon",[["name","remove"]],null,null,null,b.U,b.o)),t["\u0275did"](106,49152,null,0,i.IonIcon,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],{name:[0,"name"]},null),(l()(),t["\u0275eld"](107,0,null,null,1,"span",[["class","val"]],null,null,null,null,null)),(l()(),t["\u0275ted"](108,null,["",""])),(l()(),t["\u0275eld"](109,0,null,null,2,"span",[["class","right"],["tappable",""]],null,[[null,"click"]],function(l,n,e){var t=!0;return"click"===n&&(t=!1!==l.component.addDay(1)&&t),t},null,null)),(l()(),t["\u0275eld"](110,0,null,null,1,"ion-icon",[["name","add"]],null,null,null,b.U,b.o)),t["\u0275did"](111,49152,null,0,i.IonIcon,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],{name:[0,"name"]},null),(l()(),t["\u0275eld"](112,0,null,null,9,"div",[["class","form-group"]],null,null,null,null,null)),(l()(),t["\u0275eld"](113,0,null,null,3,"div",[["class","form-label"]],null,null,null,null,null)),(l()(),t["\u0275eld"](114,0,null,null,1,"span",[["class","required"]],null,null,null,null,null)),(l()(),t["\u0275ted"](-1,null,["*"])),(l()(),t["\u0275ted"](-1,null,["\u6574\u6539\u4eba "])),(l()(),t["\u0275eld"](117,0,null,null,4,"div",[["class","form-control"],["tappable",""]],null,[[null,"click"]],function(l,n,e){var t=!0;return"click"===n&&(t=!1!==l.component.selectMan1()&&t),t},null,null)),(l()(),t["\u0275eld"](118,0,null,null,1,"span",[["class","select-val"]],null,null,null,null,null)),(l()(),t["\u0275ted"](119,null,["",""])),(l()(),t["\u0275eld"](120,0,null,null,1,"ion-icon",[["name","arrow-forward"]],null,null,null,b.U,b.o)),t["\u0275did"](121,49152,null,0,i.IonIcon,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],{name:[0,"name"]},null),(l()(),t["\u0275eld"](122,0,null,null,9,"div",[["class","form-group"]],null,null,null,null,null)),(l()(),t["\u0275eld"](123,0,null,null,3,"div",[["class","form-label"]],null,null,null,null,null)),(l()(),t["\u0275eld"](124,0,null,null,1,"span",[["class","required"]],null,null,null,null,null)),(l()(),t["\u0275ted"](-1,null,["*"])),(l()(),t["\u0275ted"](-1,null,["\u590d\u6838\u4eba "])),(l()(),t["\u0275eld"](127,0,null,null,4,"div",[["class","form-control"],["tappable",""]],null,[[null,"click"]],function(l,n,e){var t=!0;return"click"===n&&(t=!1!==l.component.selectMan2()&&t),t},null,null)),(l()(),t["\u0275eld"](128,0,null,null,1,"span",[["class","select-val"]],null,null,null,null,null)),(l()(),t["\u0275ted"](129,null,["",""])),(l()(),t["\u0275eld"](130,0,null,null,1,"ion-icon",[["name","arrow-forward"]],null,null,null,b.U,b.o)),t["\u0275did"](131,49152,null,0,i.IonIcon,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],{name:[0,"name"]},null),(l()(),t["\u0275eld"](132,0,null,null,15,"ion-footer",[],null,null,null,b.R,b.l)),t["\u0275did"](133,49152,null,0,i.IonFooter,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],null,null),(l()(),t["\u0275eld"](134,0,null,0,13,"ion-grid",[],null,null,null,b.S,b.m)),t["\u0275did"](135,49152,null,0,i.IonGrid,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],null,null),(l()(),t["\u0275eld"](136,0,null,0,11,"ion-row",[],null,null,null,b.cb,b.w)),t["\u0275did"](137,49152,null,0,i.IonRow,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],null,null),(l()(),t["\u0275eld"](138,0,null,0,4,"ion-col",[["col-6",""]],null,null,null,b.O,b.i)),t["\u0275did"](139,49152,null,0,i.IonCol,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],null,null),(l()(),t["\u0275eld"](140,0,null,0,2,"ion-button",[["expand","block"],["fill","outline"]],null,[[null,"click"]],function(l,n,e){var t=!0;return"click"===n&&(t=!1!==l.component.reset()&&t),t},b.I,b.c)),t["\u0275did"](141,49152,null,0,i.IonButton,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],{expand:[0,"expand"],fill:[1,"fill"]},null),(l()(),t["\u0275ted"](-1,0,["\u91cd \u7f6e"])),(l()(),t["\u0275eld"](143,0,null,0,4,"ion-col",[["col-6",""]],null,null,null,b.O,b.i)),t["\u0275did"](144,49152,null,0,i.IonCol,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],null,null),(l()(),t["\u0275eld"](145,0,null,0,2,"ion-button",[["expand","block"]],null,[[null,"click"]],function(l,n,e){var t=!0;return"click"===n&&(t=!1!==l.component.createQue()&&t),t},b.I,b.c)),t["\u0275did"](146,49152,null,0,i.IonButton,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],{expand:[0,"expand"]},null),(l()(),t["\u0275ted"](-1,0,["\u4fdd \u5b58"]))],function(l,n){var e=n.component;l(n,3,0,"primary"),l(n,27,0,e.que_data.images),l(n,35,0,e.que_data.position_desc),l(n,38,0,"\u8bf7\u8f93\u5165\u90e8\u4f4d\u63cf\u8ff0"),l(n,49,0,"arrow-forward"),l(n,59,0,"arrow-forward"),l(n,69,0,"arrow-forward"),l(n,79,0,e.que_data.problem_name),l(n,82,0,"\u8bf7\u8f93\u5165\u95ee\u9898\u8bf4\u660e","3"),l(n,85,0,e.standNames),l(n,96,0,"arrow-forward"),l(n,106,0,"remove"),l(n,111,0,"add"),l(n,121,0,"arrow-forward"),l(n,131,0,"arrow-forward"),l(n,141,0,"block","outline"),l(n,146,0,"block")},function(l,n){var e=n.component;l(n,19,0,e.project.name),l(n,32,0,t["\u0275nov"](n,37).ngClassUntouched,t["\u0275nov"](n,37).ngClassTouched,t["\u0275nov"](n,37).ngClassPristine,t["\u0275nov"](n,37).ngClassDirty,t["\u0275nov"](n,37).ngClassValid,t["\u0275nov"](n,37).ngClassInvalid,t["\u0275nov"](n,37).ngClassPending),l(n,47,0,e.que_data.checkup_type||"\u8bf7\u9009\u62e9"),l(n,57,0,e.formatQueNames()),l(n,67,0,e.formatQueNames2()),l(n,76,0,t["\u0275nov"](n,81).ngClassUntouched,t["\u0275nov"](n,81).ngClassTouched,t["\u0275nov"](n,81).ngClassPristine,t["\u0275nov"](n,81).ngClassDirty,t["\u0275nov"](n,81).ngClassValid,t["\u0275nov"](n,81).ngClassInvalid,t["\u0275nov"](n,81).ngClassPending),l(n,94,0,e.que_data.level_name||"\u8bf7\u9009\u62e9"),l(n,108,0,e.que_data.istand_day),l(n,119,0,e.que_data.oper_man?e.que_data.oper_man.name:"\u8bf7\u9009\u62e9"),l(n,129,0,e.que_data.auth_man?e.que_data.auth_man.name:"\u8bf7\u9009\u62e9")})}function w(l){return t["\u0275vid"](0,[(l()(),t["\u0275eld"](0,0,null,null,1,"app-add-que",[],null,null,null,R,k)),t["\u0275did"](1,245760,null,0,_,[a.a,s.a,c.a,i.Events,m.a,i.ModalController,u.j],null,null)],function(l,n){l(n,1,0)},null)}var D=t["\u0275ccf"]("app-add-que",_,w,{},{},[]),O=e("ZYCi"),x=e("9LwV"),N=e("l4Sw"),j=e("j1ZV"),E=e("PdO7");e.d(n,"AddQuePageModuleNgFactory",function(){return T});var T=t["\u0275cmf"](h,[],function(l){return t["\u0275mod"]([t["\u0275mpd"](512,t.ComponentFactoryResolver,t["\u0275CodegenComponentFactoryResolver"],[[8,[f.a,g.a,v.a,C.a,D]],[3,t.ComponentFactoryResolver],t.NgModuleRef]),t["\u0275mpd"](4608,P.NgLocalization,P.NgLocaleLocalization,[t.LOCALE_ID,[2,P["\u0275angular_packages_common_common_a"]]]),t["\u0275mpd"](4608,y["\u0275angular_packages_forms_forms_j"],y["\u0275angular_packages_forms_forms_j"],[]),t["\u0275mpd"](4608,i.AngularDelegate,i.AngularDelegate,[t.NgZone,t.ApplicationRef]),t["\u0275mpd"](4608,i.ModalController,i.ModalController,[i.AngularDelegate,t.ComponentFactoryResolver,t.Injector]),t["\u0275mpd"](4608,i.PopoverController,i.PopoverController,[i.AngularDelegate,t.ComponentFactoryResolver,t.Injector]),t["\u0275mpd"](1073742336,P.CommonModule,P.CommonModule,[]),t["\u0275mpd"](1073742336,y["\u0275angular_packages_forms_forms_bc"],y["\u0275angular_packages_forms_forms_bc"],[]),t["\u0275mpd"](1073742336,y.FormsModule,y.FormsModule,[]),t["\u0275mpd"](1073742336,i.IonicModule,i.IonicModule,[]),t["\u0275mpd"](1073742336,O.n,O.n,[[2,O.t],[2,O.m]]),t["\u0275mpd"](1073742336,x.a,x.a,[]),t["\u0275mpd"](1073742336,N.a,N.a,[]),t["\u0275mpd"](1073742336,j.a,j.a,[]),t["\u0275mpd"](1073742336,E.a,E.a,[]),t["\u0275mpd"](1073742336,h,h,[]),t["\u0275mpd"](1024,O.k,function(){return[[{path:"",component:_}]]},[])])})}}]);