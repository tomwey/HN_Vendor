(window.webpackJsonp=window.webpackJsonp||[]).push([[34],{"8z7o":function(n,l,t){"use strict";t.r(l);var e=t("CcnG"),o=t("mrSG"),i=t("A6Y8"),a=t("ZZ/e"),u=t("Ja+p"),s=t("H+bZ"),c=t("6mc2"),d=t("sJLo"),r=function(){function n(n,l,t,e,o,i){this.taskData=n,this.nav=l,this.alertCtrl=t,this.api=e,this.tools=o,this.navCtrl=i,this.task={},this.task=Object.assign({},JSON.parse(sessionStorage.getItem("task")))}return n.prototype.ngOnInit=function(){},n.prototype.formatDays=function(){var n=this.task.iscomplete,l=parseInt(this.task.iday);return"0"===n?0===l?"\u4e0d\u52301\u5929":l>0?"\u8fd8\u5269 "+l+" \u5929":"\u8d85\u671f "+-l+" \u5929":0===l?"\u6309\u671f\u5b8c\u6210":l>0?"\u63d0\u524d "+l+" \u5929":"\u8d85\u671f "+-l+" \u5929"},n.prototype.newProblem=function(){this.nav.push("add-que",{plan_mid:this.task.plan_mid,fromType:"0",backTo:"task-detail",checkup_id:this.task.checkup_id,checkup_type:this.task.checkup_name1})},n.prototype.done=function(){return o.__awaiter(this,void 0,void 0,function(){var n=this;return o.__generator(this,function(l){switch(l.label){case 0:return[4,this.alertCtrl.create({header:"\u5b8c\u6210\u786e\u8ba4",message:"\u60a8\u786e\u5b9a\u5417\uff1f",buttons:[{text:"\u53d6\u6d88",role:"cancel",cssClass:"secondary",handler:function(n){}},{text:"\u786e\u5b9a",handler:function(){n.api.POST(null,{dotype:"GetData",funname:"\u8d28\u68c0\u7cfb\u7edf\u95ee\u9898\u8ba1\u5212\u786e\u8ba4APP",param1:n.task.plan_mid||"0",param2:"",param3:d.a.getManID(),param4:""}).then(function(l){0===l.code&&(n.task.iscomplete="1",n.navCtrl.navigateBack("/task-list"))}).catch(function(l){n.tools.showToast(l.message)})}}]})];case 1:return[4,l.sent().present()];case 2:return l.sent(),[2]}})})},n}(),p=function(){return function(){}}(),f=t("pMnS"),g=t("oBZk"),m=t("Ip0R"),h=e["\u0275crt"]({encapsulation:0,styles:[[".stat-box[_ngcontent-%COMP%]{text-align:center;font-size:12px;color:#999}.stat-box[_ngcontent-%COMP%]   .value[_ngcontent-%COMP%]{font-size:18px;font-family:'PingFang SC';color:#e75a16}.stat-box[_ngcontent-%COMP%]   .unit[_ngcontent-%COMP%]{font-size:10px;color:#999}.stat-box[_ngcontent-%COMP%]   .done[_ngcontent-%COMP%]{color:#7fb762}.stat-box[_ngcontent-%COMP%]   .type[_ngcontent-%COMP%]{color:#333}.summary-wrap[_ngcontent-%COMP%]{padding:15px;display:flex;align-items:center}.summary-wrap[_ngcontent-%COMP%]   .time-info[_ngcontent-%COMP%]{flex:1;font-size:12px;color:#999}.summary-wrap[_ngcontent-%COMP%]   .time-info[_ngcontent-%COMP%]   .left-days[_ngcontent-%COMP%]{display:inline-block;margin-left:5px;color:#e75a16}.summary-wrap[_ngcontent-%COMP%]   .state-info[_ngcontent-%COMP%]{flex:0 0 80px;text-align:right}.summary-wrap[_ngcontent-%COMP%]   .state-info[_ngcontent-%COMP%]   .state[_ngcontent-%COMP%]{display:inline-block;padding:4px 10px;background:#e75a16;color:#fff;border-radius:2px;font-size:10px;font-family:'PingFang SC';line-height:10px;vertical-align:middle}"]],data:{}});function C(n){return e["\u0275vid"](0,[(n()(),e["\u0275eld"](0,0,null,null,13,"ion-grid",[],null,null,null,g.S,g.m)),e["\u0275did"](1,49152,null,0,a.IonGrid,[e.ChangeDetectorRef,e.ElementRef,e.NgZone],null,null),(n()(),e["\u0275eld"](2,0,null,0,11,"ion-row",[],null,null,null,g.cb,g.w)),e["\u0275did"](3,49152,null,0,a.IonRow,[e.ChangeDetectorRef,e.ElementRef,e.NgZone],null,null),(n()(),e["\u0275eld"](4,0,null,0,4,"ion-col",[["size","6"]],null,null,null,g.O,g.i)),e["\u0275did"](5,49152,null,0,a.IonCol,[e.ChangeDetectorRef,e.ElementRef,e.NgZone],{size:[0,"size"]},null),(n()(),e["\u0275eld"](6,0,null,0,2,"ion-button",[["color","light"],["expand","full"]],null,[[null,"click"]],function(n,l,t){var e=!0;return"click"===l&&(e=!1!==n.component.newProblem()&&e),e},g.I,g.c)),e["\u0275did"](7,49152,null,0,a.IonButton,[e.ChangeDetectorRef,e.ElementRef,e.NgZone],{color:[0,"color"],expand:[1,"expand"]},null),(n()(),e["\u0275ted"](-1,0,["\u53cd\u9988\u95ee\u9898"])),(n()(),e["\u0275eld"](9,0,null,0,4,"ion-col",[["size","6"]],null,null,null,g.O,g.i)),e["\u0275did"](10,49152,null,0,a.IonCol,[e.ChangeDetectorRef,e.ElementRef,e.NgZone],{size:[0,"size"]},null),(n()(),e["\u0275eld"](11,0,null,0,2,"ion-button",[["expand","full"]],null,[[null,"click"]],function(n,l,t){var e=!0;return"click"===l&&(e=!1!==n.component.done()&&e),e},g.I,g.c)),e["\u0275did"](12,49152,null,0,a.IonButton,[e.ChangeDetectorRef,e.ElementRef,e.NgZone],{expand:[0,"expand"]},null),(n()(),e["\u0275ted"](-1,0,["\u786e\u8ba4\u5b8c\u6210"]))],function(n,l){n(l,5,0,"6"),n(l,7,0,"light","full"),n(l,10,0,"6"),n(l,12,0,"full")},null)}function y(n){return e["\u0275vid"](0,[(n()(),e["\u0275eld"](0,0,null,null,11,"ion-header",[["no-border",""]],null,null,null,g.T,g.n)),e["\u0275did"](1,49152,null,0,a.IonHeader,[e.ChangeDetectorRef,e.ElementRef,e.NgZone],null,null),(n()(),e["\u0275eld"](2,0,null,0,9,"ion-toolbar",[["color","primary"]],null,null,null,g.kb,g.E)),e["\u0275did"](3,49152,null,0,a.IonToolbar,[e.ChangeDetectorRef,e.ElementRef,e.NgZone],{color:[0,"color"]},null),(n()(),e["\u0275eld"](4,0,null,0,4,"ion-buttons",[["slot","start"]],null,null,null,g.J,g.d)),e["\u0275did"](5,49152,null,0,a.IonButtons,[e.ChangeDetectorRef,e.ElementRef,e.NgZone],null,null),(n()(),e["\u0275eld"](6,0,null,0,2,"ion-back-button",[["default-href","task-list"]],null,[[null,"click"]],function(n,l,t){var o=!0;return"click"===l&&(o=!1!==e["\u0275nov"](n,8).onClick(t)&&o),o},g.H,g.b)),e["\u0275did"](7,49152,null,0,a.IonBackButton,[e.ChangeDetectorRef,e.ElementRef,e.NgZone],null,null),e["\u0275did"](8,16384,null,0,a.IonBackButtonDelegate,[[2,a.IonRouterOutlet],a.NavController],null,null),(n()(),e["\u0275eld"](9,0,null,0,2,"ion-title",[],null,null,null,g.jb,g.D)),e["\u0275did"](10,49152,null,0,a.IonTitle,[e.ChangeDetectorRef,e.ElementRef,e.NgZone],null,null),(n()(),e["\u0275ted"](-1,0,["\u4efb\u52a1\u8be6\u60c5"])),(n()(),e["\u0275eld"](12,0,null,null,51,"ion-content",[],null,null,null,g.P,g.j)),e["\u0275did"](13,49152,null,0,a.IonContent,[e.ChangeDetectorRef,e.ElementRef,e.NgZone],null,null),(n()(),e["\u0275eld"](14,0,null,0,47,"ion-card",[],null,null,null,g.N,g.e)),e["\u0275did"](15,49152,null,0,a.IonCard,[e.ChangeDetectorRef,e.ElementRef,e.NgZone],null,null),(n()(),e["\u0275eld"](16,0,null,0,4,"ion-card-header",[],null,null,null,g.K,g.f)),e["\u0275did"](17,49152,null,0,a.IonCardHeader,[e.ChangeDetectorRef,e.ElementRef,e.NgZone],null,null),(n()(),e["\u0275eld"](18,0,null,0,2,"ion-card-title",[["style","font-size: 16px"]],null,null,null,g.M,g.h)),e["\u0275did"](19,49152,null,0,a.IonCardTitle,[e.ChangeDetectorRef,e.ElementRef,e.NgZone],null,null),(n()(),e["\u0275ted"](20,0,["",""])),(n()(),e["\u0275eld"](21,0,null,0,31,"ion-grid",[],null,null,null,g.S,g.m)),e["\u0275did"](22,49152,null,0,a.IonGrid,[e.ChangeDetectorRef,e.ElementRef,e.NgZone],null,null),(n()(),e["\u0275eld"](23,0,null,0,29,"ion-row",[],null,null,null,g.cb,g.w)),e["\u0275did"](24,49152,null,0,a.IonRow,[e.ChangeDetectorRef,e.ElementRef,e.NgZone],null,null),(n()(),e["\u0275eld"](25,0,null,0,9,"ion-col",[["size","4"]],null,null,null,g.O,g.i)),e["\u0275did"](26,49152,null,0,a.IonCol,[e.ChangeDetectorRef,e.ElementRef,e.NgZone],{size:[0,"size"]},null),(n()(),e["\u0275eld"](27,0,null,0,7,"div",[["class","stat-box"]],null,null,null,null,null)),(n()(),e["\u0275eld"](28,0,null,null,4,"div",[["class","value question"]],null,null,null,null,null)),(n()(),e["\u0275eld"](29,0,null,null,1,"span",[["class","digit"]],null,null,null,null,null)),(n()(),e["\u0275ted"](30,null,["",""])),(n()(),e["\u0275eld"](31,0,null,null,1,"span",[["class","unit"]],null,null,null,null,null)),(n()(),e["\u0275ted"](-1,null,["\u4e2a"])),(n()(),e["\u0275eld"](33,0,null,null,1,"div",[["class","label"]],null,null,null,null,null)),(n()(),e["\u0275ted"](-1,null,[" \u53d1\u73b0\u95ee\u9898 "])),(n()(),e["\u0275eld"](35,0,null,0,9,"ion-col",[["size","4"]],null,null,null,g.O,g.i)),e["\u0275did"](36,49152,null,0,a.IonCol,[e.ChangeDetectorRef,e.ElementRef,e.NgZone],{size:[0,"size"]},null),(n()(),e["\u0275eld"](37,0,null,0,7,"div",[["class","stat-box"]],null,null,null,null,null)),(n()(),e["\u0275eld"](38,0,null,null,4,"div",[["class","value done"]],null,null,null,null,null)),(n()(),e["\u0275eld"](39,0,null,null,1,"span",[["class","digit"]],null,null,null,null,null)),(n()(),e["\u0275ted"](40,null,["",""])),(n()(),e["\u0275eld"](41,0,null,null,1,"span",[["class","unit"]],null,null,null,null,null)),(n()(),e["\u0275ted"](-1,null,["\u4e2a"])),(n()(),e["\u0275eld"](43,0,null,null,1,"div",[["class","label"]],null,null,null,null,null)),(n()(),e["\u0275ted"](-1,null,[" \u5df2\u89e3\u51b3 "])),(n()(),e["\u0275eld"](45,0,null,0,7,"ion-col",[["size","4"]],null,null,null,g.O,g.i)),e["\u0275did"](46,49152,null,0,a.IonCol,[e.ChangeDetectorRef,e.ElementRef,e.NgZone],{size:[0,"size"]},null),(n()(),e["\u0275eld"](47,0,null,0,5,"div",[["class","stat-box"]],null,null,null,null,null)),(n()(),e["\u0275eld"](48,0,null,null,2,"div",[["class","value type"]],null,null,null,null,null)),(n()(),e["\u0275eld"](49,0,null,null,1,"span",[["class","digit"]],null,null,null,null,null)),(n()(),e["\u0275ted"](50,null,["",""])),(n()(),e["\u0275eld"](51,0,null,null,1,"div",[["class","label"]],null,null,null,null,null)),(n()(),e["\u0275ted"](-1,null,[" \u68c0\u67e5\u7c7b\u578b "])),(n()(),e["\u0275eld"](53,0,null,0,8,"div",[["class","summary-wrap"]],null,null,null,null,null)),(n()(),e["\u0275eld"](54,0,null,null,4,"div",[["class","time-info"]],null,null,null,null,null)),(n()(),e["\u0275eld"](55,0,null,null,1,"span",[["class","time"]],null,null,null,null,null)),(n()(),e["\u0275ted"](56,null,[""," ~ ",""])),(n()(),e["\u0275eld"](57,0,null,null,1,"span",[["class","left-days"]],null,null,null,null,null)),(n()(),e["\u0275ted"](58,null,["",""])),(n()(),e["\u0275eld"](59,0,null,null,2,"div",[["class","state-info"]],null,null,null,null,null)),(n()(),e["\u0275eld"](60,0,null,null,1,"span",[["class","state"]],null,null,null,null,null)),(n()(),e["\u0275ted"](61,null,["",""])),(n()(),e["\u0275and"](16777216,null,0,1,null,C)),e["\u0275did"](63,16384,null,0,m.NgIf,[e.ViewContainerRef,e.TemplateRef],{ngIf:[0,"ngIf"]},null)],function(n,l){var t=l.component;n(l,3,0,"primary"),n(l,26,0,"4"),n(l,36,0,"4"),n(l,46,0,"4"),n(l,63,0,"0"===t.task.iscomplete)},function(n,l){var t=l.component;n(l,20,0,t.task.plan_name),n(l,30,0,t.task.icount_problem),n(l,40,0,t.task.icount_problem_finish),n(l,50,0,t.task.checkup_name1),n(l,56,0,t.task.plan_begin_date,t.task.plan_end_date),n(l,58,0,t.formatDays()),n(l,61,0,t.task.state_desc)})}function v(n){return e["\u0275vid"](0,[(n()(),e["\u0275eld"](0,0,null,null,1,"app-task-detail",[],null,null,null,y,h)),e["\u0275did"](1,114688,null,0,r,[i.a,u.a,a.AlertController,s.a,c.a,a.NavController],null,null)],function(n,l){n(l,1,0)},null)}var b=e["\u0275ccf"]("app-task-detail",r,v,{},{},[]),_=t("gIcY"),D=t("ZYCi");t.d(l,"TaskDetailPageModuleNgFactory",function(){return k});var k=e["\u0275cmf"](p,[],function(n){return e["\u0275mod"]([e["\u0275mpd"](512,e.ComponentFactoryResolver,e["\u0275CodegenComponentFactoryResolver"],[[8,[f.a,b]],[3,e.ComponentFactoryResolver],e.NgModuleRef]),e["\u0275mpd"](4608,m.NgLocalization,m.NgLocaleLocalization,[e.LOCALE_ID,[2,m["\u0275angular_packages_common_common_a"]]]),e["\u0275mpd"](4608,_["\u0275angular_packages_forms_forms_j"],_["\u0275angular_packages_forms_forms_j"],[]),e["\u0275mpd"](4608,a.AngularDelegate,a.AngularDelegate,[e.NgZone,e.ApplicationRef]),e["\u0275mpd"](4608,a.ModalController,a.ModalController,[a.AngularDelegate,e.ComponentFactoryResolver,e.Injector]),e["\u0275mpd"](4608,a.PopoverController,a.PopoverController,[a.AngularDelegate,e.ComponentFactoryResolver,e.Injector]),e["\u0275mpd"](1073742336,m.CommonModule,m.CommonModule,[]),e["\u0275mpd"](1073742336,_["\u0275angular_packages_forms_forms_bc"],_["\u0275angular_packages_forms_forms_bc"],[]),e["\u0275mpd"](1073742336,_.FormsModule,_.FormsModule,[]),e["\u0275mpd"](1073742336,a.IonicModule,a.IonicModule,[]),e["\u0275mpd"](1073742336,D.n,D.n,[[2,D.t],[2,D.m]]),e["\u0275mpd"](1073742336,p,p,[]),e["\u0275mpd"](1024,D.k,function(){return[[{path:"",component:r}]]},[])])})},A6Y8:function(n,l,t){"use strict";t.d(l,"a",function(){return s});var e=t("ajt+"),o=t("H+bZ"),i=t("fLog"),a=t("6mc2"),u=t("CcnG"),s=function(){function n(n,l,t){this.db=n,this.api=l,this.tools=t}return n.prototype.getTasks=function(n,l,t,e){var o=this;void 0===e&&(e=!0),e&&this.tools.showLoading(),60!==n&&70!==n?this.db.initDB().then(function(){o.db.getSingleCondData(i.l,"iscomplete",l.toString(),function(n){t&&t(n),o.tools.hideLoading()})}):this.db.initDB().then(function(){o.db.getSingleCondData(i.l,"type_complete",[n.toString(),l.toString()],function(n){t&&t(n),o.tools.hideLoading()})})},n.prototype.getBuildings=function(n,l,t,e){var o=this;void 0===n&&(n=0),void 0===t&&(t="0"),void 0===e&&(e=""),this.db.initDB().then(function(){o.db.getBuildings("1",null,n,l,t,e)})},n.prototype.confirmDone=function(n,l){var t=this,e=Object.assign({},n);e.iscomplete="1",e.isupdate="1",this.db.initDB().then(function(){t.db.update(i.l,[e],function(t){n.iscomplete="1",l&&l()})})},n.prototype.getUnits=function(n,l,t,e,o){var i=this;void 0===o&&(o=""),this.db.initDB().then(function(){i.db.getBuildings("0",l,n,t,e,o)})},n.prototype.getFloors=function(n,l,t,e,o){var i=this;void 0===o&&(o=""),this.db.initDB().then(function(){i.db.getBuildings("0",l,n,function(l){l.forEach(function(l){i.db.getBuildings("0",l.tree_mid,n,function(n){n.sort(function(n,l){return parseInt(n.iorder)-parseInt(l.iorder)}),l.rooms=n},e,o)}),t&&t(l)},e,o)})},n.prototype.getFloors2=function(n,l,t,e,o,i){var a=this;void 0===o&&(o=""),void 0===i&&(i=!0),this.db.initDB().then(function(){a.db.getBuildings("0",l,n,function(l){l.forEach(function(l){a.db.getBuildings("0",l.tree_mid,n,function(n){var t=[];(t=i?n:n.filter(function(n){return"\u5b8c\u6210"!==n.state_desc})).sort(function(n,l){return parseInt(n.iorder)-parseInt(l.iorder)}),l.rooms=t},e,o)}),t&&t(l)},e,o)})},n.prototype.getListInHouse=function(n,l,t){var e=this;this.db.initDB().then(function(){e.db.getListInhouse(l,function(n){t&&t(n)})})},n.prototype.getListInHouse2=function(n,l,t,e){var o=this;this.db.initDB().then(function(){o.db.getSingleCondData("list_inhouse","objtypename",t,function(t){t.forEach(function(t){o.db.getPartialsInHouse2(n,l,t.position_id,function(l){console.log(l);var e=[],o={},i=[];l.forEach(function(l){if(l.template_type===n){var a=l.qatype_name+"|"+l.qatype_id;-1===e.indexOf(a)&&(e.push(a),i.push({qatype_id:l.qatype_id,qatype_name:l.qatype_name}));var u=o[a]||[];l.pro_position_id=t.pro_position_id,u.push(l),o[a]=u}}),t.check_items=i,t.type_items=o})}),e&&e(t)})})},n.prototype.getAccountTypes=function(n){var l=this;this.db.initDB().then(function(){l.db.select(i.c,[],{},function(l){n&&n(l)})})},n.prototype.getCheckTypes=function(n){var l=this;this.db.initDB().then(function(){l.db.select(i.d,[],{},function(l){n&&n(l)})})},n.prototype.getTypeCompanies=function(n,l){var t=this;this.db.initDB().then(function(){t.db.getSingleCondData(i.a,"accountType",n,function(n){var t=[],e=[];n.forEach(function(n){-1===t.indexOf(n.companyname)&&(t.push(n.companyname),e.push({name:n.companyname,rawData:n}))}),l&&l(e)})})},n.prototype.getTypeCompanies2=function(n,l){var t=this;this.db.initDB().then(function(){t.db.getSingleCondData(i.b,"accountType",n,function(t){console.log("fsfsdfdsfdsfdsf:",n,n);var e=[],o=[];t.forEach(function(n){-1===e.indexOf(n.companyname)&&(e.push(n.companyname),o.push({name:n.companyname,rawData:n}))}),l&&l(o)})})},n.prototype.getStationsOrMen=function(n,l){var t=this;this.db.initDB().then(function(){t.db.getSingleCondData(i.a,"contractId",n,function(n){var t=[],e=[],o=[];n.forEach(function(n){"1"===n.ismanage&&-1===o.indexOf(n.id)&&(o.push(n.id),t.push({name:n.manname,id:n.id,type:"2",rawData:n})),-1===e.indexOf(n.stationid)&&(e.push(n.stationid),t.push({name:n.stationname,id:n.stationid,type:"3",rawData:n}))}),l&&l(t)})})},n.prototype.getStationsOrMen2=function(n,l){var t=this;this.db.initDB().then(function(){console.log("conid======",n),t.db.getSingleCondData(i.b,"contractId",n,function(n){var t=[],e=[],o=[];n.forEach(function(n){"1"===n.ismanage&&-1===o.indexOf(n.id)&&(o.push(n.id),t.push({name:n.manname,id:n.id,type:"2",rawData:n})),-1===e.indexOf(n.stationid)&&(e.push(n.stationid),t.push({name:n.stationname,id:n.stationid,type:"3",rawData:n}))}),l&&l(t)})})},n.prototype.getCompanyContracts2=function(n,l){var t=this;this.db.initDB().then(function(){t.db.getSingleCondData(i.b,"companyName",n,function(n){var t=[],e=[],o=[],i=[];n.forEach(function(n){n.contractname&&"NULL"!==n.contractname?-1===t.indexOf(n.contractid)&&(t.push(n.contractid),e.push({name:n.contractname,id:n.contractid,type:"1",rawData:n})):("1"===n.ismanage&&-1===i.indexOf(n.id)&&(i.push(n.id),e.push({name:n.manname,id:n.id,type:"2",rawData:n})),-1===o.indexOf(n.stationid)&&(o.push(n.stationid),e.push({name:n.stationname,id:n.stationid,type:"3",rawData:n})))}),l&&l(e)})})},n.prototype.getCompanyContracts=function(n,l){var t=this;this.db.initDB().then(function(){t.db.getSingleCondData(i.a,"companyName",n,function(n){var t=[],e=[],o=[],i=[];n.forEach(function(n){n.contractname&&"NULL"!==n.contractname?-1===t.indexOf(n.contractid)&&(t.push(n.contractid),e.push({name:n.contractname,id:n.contractid,type:"1",rawData:n})):("1"===n.ismanage&&-1===i.indexOf(n.id)&&(i.push(n.id),e.push({name:n.manname,id:n.id,type:"2",rawData:n})),-1===o.indexOf(n.stationid)&&(o.push(n.stationid),e.push({name:n.stationname,id:n.stationid,type:"3",rawData:n})))}),l&&l(e)})})},n.ngInjectableDef=u.defineInjectable({factory:function(){return new n(u.inject(e.a),u.inject(o.a),u.inject(a.a))},token:n,providedIn:"root"}),n}()},"Ja+p":function(n,l,t){"use strict";t.d(l,"a",function(){return i});var e=t("ZZ/e"),o=t("CcnG"),i=function(){function n(n){this.navCtrl=n}return n.prototype.push=function(n,l){void 0===l&&(l={}),this.data=l,this.navCtrl.navigateForward("/"+(n||""))},n.prototype.pop=function(n){this.navCtrl.navigateBack("/"+(n||""))},n.prototype.get=function(n){return this.data[n]},n.ngInjectableDef=o.defineInjectable({factory:function(){return new n(o.inject(e.NavController))},token:n,providedIn:"root"}),n}()}}]);