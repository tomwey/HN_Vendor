(window.webpackJsonp=window.webpackJsonp||[]).push([[35],{A6Y8:function(n,t,e){"use strict";e.d(t,"a",function(){return s});var l=e("ajt+"),o=e("H+bZ"),i=e("fLog"),a=e("6mc2"),c=e("CcnG"),s=function(){function n(n,t,e){this.db=n,this.api=t,this.tools=e}return n.prototype.getTasks=function(n,t,e,l){var o=this;void 0===l&&(l=!0),l&&this.tools.showLoading(),60!==n&&70!==n?this.db.initDB().then(function(){o.db.getSingleCondData(i.l,"iscomplete",t.toString(),function(n){e&&e(n),o.tools.hideLoading()})}):this.db.initDB().then(function(){o.db.getSingleCondData(i.l,"type_complete",[n.toString(),t.toString()],function(n){e&&e(n),o.tools.hideLoading()})})},n.prototype.getBuildings=function(n,t,e,l){var o=this;void 0===n&&(n=0),void 0===e&&(e="0"),void 0===l&&(l=""),this.db.initDB().then(function(){o.db.getBuildings("1",null,n,t,e,l)})},n.prototype.confirmDone=function(n,t){var e=this,l=Object.assign({},n);l.iscomplete="1",l.isupdate="1",this.db.initDB().then(function(){e.db.update(i.l,[l],function(e){n.iscomplete="1",t&&t()})})},n.prototype.getUnits=function(n,t,e,l,o){var i=this;void 0===o&&(o=""),this.db.initDB().then(function(){i.db.getBuildings("0",t,n,e,l,o)})},n.prototype.getFloors=function(n,t,e,l,o){var i=this;void 0===o&&(o=""),this.db.initDB().then(function(){i.db.getBuildings("0",t,n,function(t){t.forEach(function(t){i.db.getBuildings("0",t.tree_mid,n,function(n){n.sort(function(n,t){return parseInt(n.iorder)-parseInt(t.iorder)}),t.rooms=n},l,o)}),e&&e(t)},l,o)})},n.prototype.getFloors2=function(n,t,e,l,o,i){var a=this;void 0===o&&(o=""),void 0===i&&(i=!0),this.db.initDB().then(function(){a.db.getBuildings("0",t,n,function(t){t.forEach(function(t){a.db.getBuildings("0",t.tree_mid,n,function(n){var e=[];(e=i?n:n.filter(function(n){return"\u5b8c\u6210"!==n.state_desc})).sort(function(n,t){return parseInt(n.iorder)-parseInt(t.iorder)}),t.rooms=e},l,o)}),e&&e(t)},l,o)})},n.prototype.getListInHouse=function(n,t,e){var l=this;this.db.initDB().then(function(){l.db.getListInhouse(t,function(n){e&&e(n)})})},n.prototype.getListInHouse2=function(n,t,e,l){var o=this;this.db.initDB().then(function(){o.db.getSingleCondData("list_inhouse","objtypename",e,function(e){e.forEach(function(e){o.db.getPartialsInHouse2(n,t,e.position_id,function(t){console.log(t);var l=[],o={},i=[];t.forEach(function(t){if(t.template_type===n){var a=t.qatype_name+"|"+t.qatype_id;-1===l.indexOf(a)&&(l.push(a),i.push({qatype_id:t.qatype_id,qatype_name:t.qatype_name}));var c=o[a]||[];t.pro_position_id=e.pro_position_id,c.push(t),o[a]=c}}),e.check_items=i,e.type_items=o})}),l&&l(e)})})},n.prototype.getAccountTypes=function(n){var t=this;this.db.initDB().then(function(){t.db.select(i.c,[],{},function(t){n&&n(t)})})},n.prototype.getCheckTypes=function(n){var t=this;this.db.initDB().then(function(){t.db.select(i.d,[],{},function(t){n&&n(t)})})},n.prototype.getTypeCompanies=function(n,t){var e=this;this.db.initDB().then(function(){e.db.getSingleCondData(i.a,"accountType",n,function(n){var e=[],l=[];n.forEach(function(n){-1===e.indexOf(n.companyname)&&(e.push(n.companyname),l.push({name:n.companyname,rawData:n}))}),t&&t(l)})})},n.prototype.getTypeCompanies2=function(n,t){var e=this;this.db.initDB().then(function(){e.db.getSingleCondData(i.b,"accountType",n,function(e){console.log("fsfsdfdsfdsfdsf:",n,n);var l=[],o=[];e.forEach(function(n){-1===l.indexOf(n.companyname)&&(l.push(n.companyname),o.push({name:n.companyname,rawData:n}))}),t&&t(o)})})},n.prototype.getStationsOrMen=function(n,t){var e=this;this.db.initDB().then(function(){e.db.getSingleCondData(i.a,"contractId",n,function(n){var e=[],l=[],o=[];n.forEach(function(n){"1"===n.ismanage&&-1===o.indexOf(n.id)&&(o.push(n.id),e.push({name:n.manname,id:n.id,type:"2",rawData:n})),-1===l.indexOf(n.stationid)&&(l.push(n.stationid),e.push({name:n.stationname,id:n.stationid,type:"3",rawData:n}))}),t&&t(e)})})},n.prototype.getStationsOrMen2=function(n,t){var e=this;this.db.initDB().then(function(){console.log("conid======",n),e.db.getSingleCondData(i.b,"contractId",n,function(n){var e=[],l=[],o=[];n.forEach(function(n){"1"===n.ismanage&&-1===o.indexOf(n.id)&&(o.push(n.id),e.push({name:n.manname,id:n.id,type:"2",rawData:n})),-1===l.indexOf(n.stationid)&&(l.push(n.stationid),e.push({name:n.stationname,id:n.stationid,type:"3",rawData:n}))}),t&&t(e)})})},n.prototype.getCompanyContracts2=function(n,t){var e=this;this.db.initDB().then(function(){e.db.getSingleCondData(i.b,"companyName",n,function(n){var e=[],l=[],o=[],i=[];n.forEach(function(n){n.contractname&&"NULL"!==n.contractname?-1===e.indexOf(n.contractid)&&(e.push(n.contractid),l.push({name:n.contractname,id:n.contractid,type:"1",rawData:n})):("1"===n.ismanage&&-1===i.indexOf(n.id)&&(i.push(n.id),l.push({name:n.manname,id:n.id,type:"2",rawData:n})),-1===o.indexOf(n.stationid)&&(o.push(n.stationid),l.push({name:n.stationname,id:n.stationid,type:"3",rawData:n})))}),t&&t(l)})})},n.prototype.getCompanyContracts=function(n,t){var e=this;this.db.initDB().then(function(){e.db.getSingleCondData(i.a,"companyName",n,function(n){var e=[],l=[],o=[],i=[];n.forEach(function(n){n.contractname&&"NULL"!==n.contractname?-1===e.indexOf(n.contractid)&&(e.push(n.contractid),l.push({name:n.contractname,id:n.contractid,type:"1",rawData:n})):("1"===n.ismanage&&-1===i.indexOf(n.id)&&(i.push(n.id),l.push({name:n.manname,id:n.id,type:"2",rawData:n})),-1===o.indexOf(n.stationid)&&(o.push(n.stationid),l.push({name:n.stationname,id:n.stationid,type:"3",rawData:n})))}),t&&t(l)})})},n.ngInjectableDef=c.defineInjectable({factory:function(){return new n(c.inject(l.a),c.inject(o.a),c.inject(a.a))},token:n,providedIn:"root"}),n}()},HbgP:function(n,t,e){"use strict";e.r(t);var l=e("CcnG"),o=e("ZZ/e"),i=e("A6Y8"),a=e("fLog"),c=e("Ja+p"),s=e("6mc2"),u=function(){function n(n,t,e,l,o){this.navCtrl=n,this.nav=t,this.tools=e,this.sync=l,this.taskData=o,this.tasks=[],this.error=null,this.currentTabIndex=0,this.title="\u8d28\u68c0\u4efb\u52a1"}return n.prototype.ngOnInit=function(){60===this.nav.data.type?this.title="\u6a21\u62df\u9a8c\u623f":70===this.nav.data.type&&(this.title="\u79fb\u52a8\u6536\u623f"),this.loadTask()},n.prototype.loadTask=function(){var n=this;this.tools.showLoading(),this.taskData.getTasks(this.nav.data?this.nav.data.type:"0",this.currentTabIndex,function(t){console.log(t);var e=[];t.forEach(function(t){var l=Object.assign({},t);l.project_name=n.sync.getProject().name,l.project_id=n.sync.getProject().id;var o=parseInt(t.iday);"1"===t.iscomplete?0===o?(l.days_desc="\u6309\u671f\u5b8c\u6210",l.state=20):o>0?(l.days_desc="\u63d0\u524d "+o+" \u5929",l.state=20):(l.days_desc="\u8d85\u671f "+-o+" \u5929",l.state=30):0===o?(l.days_desc="\u5373\u5c06\u5230\u671f",l.state=10):o>0?(l.days_desc="\u8fd8\u5269 "+o+" \u5929",l.state=10):(l.days_desc="\u8d85\u671f "+-o+" \u5929",l.state=40),e.push(l)}),n.tasks=e,n.error=0===n.tasks.length?"\u6682\u65e0\u6570\u636e":null,n.tools.hideLoading()})},n.prototype.selectTab=function(n){this.currentTabIndex=n,this.loadTask()},n.prototype.selectTask=function(n){console.log(n),"0"===n.task_typeid?(sessionStorage.setItem("task",JSON.stringify(n)),this.navCtrl.navigateForward("/task-detail")):(n.fromType="1",this.nav.push("check-place-home",n))},n}(),r=function(){return function(){}}(),d=e("pMnS"),p=e("Ip0R"),g=e("oBZk"),f=l["\u0275crt"]({encapsulation:0,styles:[['.subbar[_ngcontent-%COMP%]{border-bottom:.55px solid #f2f2f2}.subbar[_ngcontent-%COMP%]   .bar-item[_ngcontent-%COMP%]{display:inline-block;width:50%;text-align:center;height:44px;line-height:44px;font-size:12px;color:#333;background:#fff;border-right:.55px solid #f2f2f2;position:relative}.subbar[_ngcontent-%COMP%]   .bar-item.active[_ngcontent-%COMP%]::after{content:"";display:block;width:28px;height:2px;background:var(--ion-color-primary);position:absolute;bottom:-1px;left:50%;margin-left:-14px}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]{border-bottom:.55px solid #f2f2f2;padding:10px 15px;display:flex;align-items:center}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .left[_ngcontent-%COMP%]{flex:1;padding-right:10px}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .left[_ngcontent-%COMP%]   h2[_ngcontent-%COMP%], .tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .left[_ngcontent-%COMP%]   p[_ngcontent-%COMP%]{margin:0;padding:0}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .left[_ngcontent-%COMP%]   .name-wrap[_ngcontent-%COMP%]{font-size:14px;line-height:14px;font-weight:400;color:#333;margin-bottom:8px;vertical-align:middle}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .left[_ngcontent-%COMP%]   .name-wrap[_ngcontent-%COMP%]   .name[_ngcontent-%COMP%]{line-height:18px}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .left[_ngcontent-%COMP%]   .type[_ngcontent-%COMP%]{display:inline-block;padding:2px 3px;background:#e75a16;color:#fff;font-size:10px;line-height:12px;vertical-align:1px;border-radius:2px;margin-right:5px}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .left[_ngcontent-%COMP%]   .type.type-10[_ngcontent-%COMP%]{background:#4a4a4a}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .left[_ngcontent-%COMP%]   .type.type-20[_ngcontent-%COMP%]{background:#f6a623}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .left[_ngcontent-%COMP%]   .type.type-30[_ngcontent-%COMP%]{background:#8b572a}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .left[_ngcontent-%COMP%]   .type.type-40[_ngcontent-%COMP%]{background:#4990e2}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .left[_ngcontent-%COMP%]   .type.type-50[_ngcontent-%COMP%]{background:#5ac59f}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .left[_ngcontent-%COMP%]   .type.type-60[_ngcontent-%COMP%]{background:#bd5450}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .left[_ngcontent-%COMP%]   .time-wrap[_ngcontent-%COMP%]{font-size:12px;color:#666}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .left[_ngcontent-%COMP%]   .time-wrap[_ngcontent-%COMP%]   .time[_ngcontent-%COMP%]{display:inline-block;margin-right:5px}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .left[_ngcontent-%COMP%]   .time-wrap[_ngcontent-%COMP%]   .left-time[_ngcontent-%COMP%]{color:#bd5450}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .left[_ngcontent-%COMP%]   .time-wrap[_ngcontent-%COMP%]   .left-time.days-10[_ngcontent-%COMP%]{color:#f6a623}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .left[_ngcontent-%COMP%]   .time-wrap[_ngcontent-%COMP%]   .left-time.days-20[_ngcontent-%COMP%]{color:#7fb762}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .right[_ngcontent-%COMP%]{flex:0 0 80px;width:80px;text-align:right}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .right[_ngcontent-%COMP%]   .questions[_ngcontent-%COMP%]{font-size:16px;color:#333}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .right[_ngcontent-%COMP%]   .questions[_ngcontent-%COMP%]   .splitor[_ngcontent-%COMP%]{padding:0 8px;color:#999}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .right[_ngcontent-%COMP%]   .questions[_ngcontent-%COMP%]   .done[_ngcontent-%COMP%]{color:#7fb762}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .right[_ngcontent-%COMP%]   .state[_ngcontent-%COMP%]{display:inline-block;font-size:14px;color:#bd5450;margin-top:6px}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .right[_ngcontent-%COMP%]   .state.state-10[_ngcontent-%COMP%]{color:#f6a623}.tasks[_ngcontent-%COMP%]   .task[_ngcontent-%COMP%]   .right[_ngcontent-%COMP%]   .state.state-20[_ngcontent-%COMP%]{color:#7fb762}']],data:{}});function m(n){return l["\u0275vid"](0,[(n()(),l["\u0275eld"](0,0,null,null,1,"div",[["class","empty-error-box"]],null,null,null,null,null)),(n()(),l["\u0275ted"](1,null,["",""]))],null,function(n,t){n(t,1,0,t.component.error)})}function h(n){return l["\u0275vid"](0,[(n()(),l["\u0275eld"](0,0,null,null,6,"div",[["class","questions"]],null,null,null,null,null)),(n()(),l["\u0275eld"](1,0,null,null,1,"span",[["class","done"]],null,null,null,null,null)),(n()(),l["\u0275ted"](2,null,["",""])),(n()(),l["\u0275eld"](3,0,null,null,1,"span",[["class","splitor"]],null,null,null,null,null)),(n()(),l["\u0275ted"](-1,null,["/"])),(n()(),l["\u0275eld"](5,0,null,null,1,"span",[["class","total"]],null,null,null,null,null)),(n()(),l["\u0275ted"](6,null,["",""]))],null,function(n,t){n(t,2,0,t.parent.context.$implicit.icount_house_finish),n(t,6,0,t.parent.context.$implicit.icount_house)})}function _(n){return l["\u0275vid"](0,[(n()(),l["\u0275eld"](0,0,null,null,17,"div",[["class","task"],["tappable",""]],null,[[null,"click"]],function(n,t,e){var l=!0;return"click"===t&&(l=!1!==n.component.selectTask(n.context.$implicit)&&l),l},null,null)),(n()(),l["\u0275eld"](1,0,null,null,11,"div",[["class","left"]],null,null,null,null,null)),(n()(),l["\u0275eld"](2,0,null,null,10,"div",[["class","base"]],null,null,null,null,null)),(n()(),l["\u0275eld"](3,0,null,null,4,"h2",[["class","name-wrap"]],null,null,null,null,null)),(n()(),l["\u0275eld"](4,0,null,null,1,"span",[],[[8,"className",0]],null,null,null,null)),(n()(),l["\u0275ted"](5,null,["",""])),(n()(),l["\u0275eld"](6,0,null,null,1,"span",[["class","name"]],null,null,null,null,null)),(n()(),l["\u0275ted"](7,null,["",""])),(n()(),l["\u0275eld"](8,0,null,null,4,"p",[["class","time-wrap"]],null,null,null,null,null)),(n()(),l["\u0275eld"](9,0,null,null,1,"span",[["class","time"]],null,null,null,null,null)),(n()(),l["\u0275ted"](10,null,[""," ~ ",""])),(n()(),l["\u0275eld"](11,0,null,null,1,"span",[],[[8,"className",0]],null,null,null,null)),(n()(),l["\u0275ted"](12,null,["",""])),(n()(),l["\u0275eld"](13,0,null,null,4,"div",[["class","right"]],null,null,null,null,null)),(n()(),l["\u0275and"](16777216,null,null,1,null,h)),l["\u0275did"](15,16384,null,0,p.NgIf,[l.ViewContainerRef,l.TemplateRef],{ngIf:[0,"ngIf"]},null),(n()(),l["\u0275eld"](16,0,null,null,1,"span",[],[[8,"className",0]],null,null,null,null)),(n()(),l["\u0275ted"](17,null,["",""]))],function(n,t){n(t,15,0,"1"===t.context.$implicit.task_typeid)},function(n,t){n(t,4,0,l["\u0275inlineInterpolate"](1,"type type-",t.context.$implicit.checkup_id,"")),n(t,5,0,t.context.$implicit.checkup_name),n(t,7,0,t.context.$implicit.plan_name),n(t,10,0,t.context.$implicit.plan_begin_date,t.context.$implicit.plan_end_date),n(t,11,0,l["\u0275inlineInterpolate"](1,"left-time days-",t.context.$implicit.state,"")),n(t,12,0,t.context.$implicit.days_desc),n(t,16,0,l["\u0275inlineInterpolate"](1,"state state-",t.context.$implicit.state,"")),n(t,17,0,t.context.$implicit.state_desc)})}function C(n){return l["\u0275vid"](0,[(n()(),l["\u0275eld"](0,0,null,null,16,"ion-header",[["no-border",""]],null,null,null,g.T,g.n)),l["\u0275did"](1,49152,null,0,o.IonHeader,[l.ChangeDetectorRef,l.ElementRef,l.NgZone],null,null),(n()(),l["\u0275eld"](2,0,null,0,9,"ion-toolbar",[["color","primary"]],null,null,null,g.kb,g.E)),l["\u0275did"](3,49152,null,0,o.IonToolbar,[l.ChangeDetectorRef,l.ElementRef,l.NgZone],{color:[0,"color"]},null),(n()(),l["\u0275eld"](4,0,null,0,4,"ion-buttons",[["slot","start"]],null,null,null,g.J,g.d)),l["\u0275did"](5,49152,null,0,o.IonButtons,[l.ChangeDetectorRef,l.ElementRef,l.NgZone],null,null),(n()(),l["\u0275eld"](6,0,null,0,2,"ion-back-button",[["default-href","home"]],null,[[null,"click"]],function(n,t,e){var o=!0;return"click"===t&&(o=!1!==l["\u0275nov"](n,8).onClick(e)&&o),o},g.H,g.b)),l["\u0275did"](7,49152,null,0,o.IonBackButton,[l.ChangeDetectorRef,l.ElementRef,l.NgZone],null,null),l["\u0275did"](8,16384,null,0,o.IonBackButtonDelegate,[[2,o.IonRouterOutlet],o.NavController],null,null),(n()(),l["\u0275eld"](9,0,null,0,2,"ion-title",[],null,null,null,g.jb,g.D)),l["\u0275did"](10,49152,null,0,o.IonTitle,[l.ChangeDetectorRef,l.ElementRef,l.NgZone],null,null),(n()(),l["\u0275ted"](11,0,["",""])),(n()(),l["\u0275eld"](12,0,null,0,4,"div",[["class","subbar"]],null,null,null,null,null)),(n()(),l["\u0275eld"](13,0,null,null,1,"div",[["class","bar-item"],["tappable",""]],[[2,"active",null]],[[null,"click"]],function(n,t,e){var l=!0;return"click"===t&&(l=!1!==n.component.selectTab(0)&&l),l},null,null)),(n()(),l["\u0275ted"](-1,null,[" \u5f85\u529e "])),(n()(),l["\u0275eld"](15,0,null,null,1,"div",[["class","bar-item"],["tappable",""]],[[2,"active",null]],[[null,"click"]],function(n,t,e){var l=!0;return"click"===t&&(l=!1!==n.component.selectTab(1)&&l),l},null,null)),(n()(),l["\u0275ted"](-1,null,[" \u5df2\u529e "])),(n()(),l["\u0275eld"](17,0,null,null,11,"ion-content",[],null,null,null,g.P,g.j)),l["\u0275did"](18,49152,null,0,o.IonContent,[l.ChangeDetectorRef,l.ElementRef,l.NgZone],null,null),(n()(),l["\u0275eld"](19,0,null,0,9,"div",[["class","tasks"]],null,null,null,null,null)),(n()(),l["\u0275and"](16777216,null,null,1,null,m)),l["\u0275did"](21,16384,null,0,p.NgIf,[l.ViewContainerRef,l.TemplateRef],{ngIf:[0,"ngIf"]},null),(n()(),l["\u0275eld"](22,0,null,null,6,"ion-virtual-scroll",[["approxItemHeight","80px"]],null,null,null,g.lb,g.F)),l["\u0275did"](23,835584,null,3,o.IonVirtualScroll,[l.NgZone,l.IterableDiffers,l.ElementRef],{approxItemHeight:[0,"approxItemHeight"],items:[1,"items"]},null),l["\u0275qud"](335544320,1,{itmTmp:0}),l["\u0275qud"](335544320,2,{hdrTmp:0}),l["\u0275qud"](335544320,3,{ftrTmp:0}),(n()(),l["\u0275and"](16777216,null,0,1,null,_)),l["\u0275did"](28,16384,[[1,4]],0,o.VirtualItem,[l.TemplateRef,l.ViewContainerRef],null,null)],function(n,t){var e=t.component;n(t,3,0,"primary"),n(t,21,0,!!e.error),n(t,23,0,"80px",e.tasks)},function(n,t){var e=t.component;n(t,11,0,e.title),n(t,13,0,0===e.currentTabIndex),n(t,15,0,1===e.currentTabIndex)})}function O(n){return l["\u0275vid"](0,[(n()(),l["\u0275eld"](0,0,null,null,1,"app-task-list",[],null,null,null,C,f)),l["\u0275did"](1,114688,null,0,u,[o.NavController,c.a,s.a,a.j,i.a],null,null)],function(n,t){n(t,1,0)},null)}var b=l["\u0275ccf"]("app-task-list",u,O,{},{},[]),M=e("gIcY"),k=e("ZYCi");e.d(t,"TaskListPageModuleNgFactory",function(){return P});var P=l["\u0275cmf"](r,[],function(n){return l["\u0275mod"]([l["\u0275mpd"](512,l.ComponentFactoryResolver,l["\u0275CodegenComponentFactoryResolver"],[[8,[d.a,b]],[3,l.ComponentFactoryResolver],l.NgModuleRef]),l["\u0275mpd"](4608,p.NgLocalization,p.NgLocaleLocalization,[l.LOCALE_ID,[2,p["\u0275angular_packages_common_common_a"]]]),l["\u0275mpd"](4608,M["\u0275angular_packages_forms_forms_j"],M["\u0275angular_packages_forms_forms_j"],[]),l["\u0275mpd"](4608,o.AngularDelegate,o.AngularDelegate,[l.NgZone,l.ApplicationRef]),l["\u0275mpd"](4608,o.ModalController,o.ModalController,[o.AngularDelegate,l.ComponentFactoryResolver,l.Injector]),l["\u0275mpd"](4608,o.PopoverController,o.PopoverController,[o.AngularDelegate,l.ComponentFactoryResolver,l.Injector]),l["\u0275mpd"](1073742336,p.CommonModule,p.CommonModule,[]),l["\u0275mpd"](1073742336,M["\u0275angular_packages_forms_forms_bc"],M["\u0275angular_packages_forms_forms_bc"],[]),l["\u0275mpd"](1073742336,M.FormsModule,M.FormsModule,[]),l["\u0275mpd"](1073742336,o.IonicModule,o.IonicModule,[]),l["\u0275mpd"](1073742336,k.n,k.n,[[2,k.t],[2,k.m]]),l["\u0275mpd"](1073742336,r,r,[]),l["\u0275mpd"](1024,k.k,function(){return[[{path:"",component:u}]]},[])])})},"Ja+p":function(n,t,e){"use strict";e.d(t,"a",function(){return i});var l=e("ZZ/e"),o=e("CcnG"),i=function(){function n(n){this.navCtrl=n}return n.prototype.push=function(n,t){void 0===t&&(t={}),this.data=t,this.navCtrl.navigateForward("/"+(n||""))},n.prototype.pop=function(n){this.navCtrl.navigateBack("/"+(n||""))},n.prototype.get=function(n){return this.data[n]},n.ngInjectableDef=o.defineInjectable({factory:function(){return new n(o.inject(l.NavController))},token:n,providedIn:"root"}),n}()}}]);