(window.webpackJsonp=window.webpackJsonp||[]).push([[47],{"2/IA":function(l,n,e){"use strict";e.r(n);var t=e("CcnG"),o=e("mrSG"),u=e("ajt+"),a=e("ZZ/e"),r=e("KH1z"),i=e("sJLo"),c=e("6mc2"),d=e("H+bZ"),s=e("wd/R"),p=(e("XDpg"),e("fLog")),g=function(){function l(l,n,e,t,o,u){this.api=l,this.db=n,this.modalCtrl=e,this.tools=t,this.navCtrl=o,this.events=u,this.pageType=10,this.que={},this.rectData={problemId:this.que.problem_id,rectMan:{id:"",name:""},rectDate:"\u5916\u5355\u4f4d\u6574\u6539",rectDesc:"",rectType:"",queReson:"",isPass:"1",queResonId:"",createId:i.a.getManID(),fromType:"APP",annexIDs:"",overdueReason:"",overdueReasonId:"",overdueDesc:"",images:[]},this.rect_data={problemId:this.que.problem_id,rectID:"",accpetManId:"",isPass:"1",acceptDesc:"",fromType:"APP",images:"",acceptDate:""},s.locale("zh"),this.que=Object.assign({},JSON.parse(sessionStorage.getItem("que")))}return l.prototype.ngOnInit=function(){},l.prototype.selectMan=function(){this.showModal("rectMan")},l.prototype.showModal=function(l){return o.__awaiter(this,void 0,void 0,function(){var n,e=this;return o.__generator(this,function(t){switch(t.label){case 0:return[4,this.modalCtrl.create({component:r.a,componentProps:{title:"\u8bf7\u9009\u62e9",type:1}})];case 1:return(n=t.sent()).onDidDismiss().then(function(n){n.data&&(e.rectData[l]=n.data)}),n.present(),[2]}})})},l.prototype.fileSelected=function(l){this.rectData.images=l},l.prototype.isPass=function(l){this.rectData.isPass=l},l.prototype.saveData=function(){var l=this;if(this.rect_data.problemId=this.que.problem_id,this.rect_data.rectID=this.que.correct_id,this.rect_data.accpetManId=i.a.getManID(),this.rect_data.acceptDate="",this.rect_data.acceptDesc=this.rectData.rectDesc,this.rect_data.isPass=this.rectData.isPass,this.rect_data.fromType="APP",this.rect_data.images=this.rectData.images.join("|"),"40"!==this.que.checkup_id&&"50"!==this.que.checkup_id&&"60"!==this.que.checkup_id&&"70"!==this.que.checkup_id||"ERP"!==localStorage.getItem("app")){if(!this.rect_data.images||0===this.rect_data.images.length)return void this.tools.showToast("\u9644\u4ef6\u4e0d\u80fd\u4e3a\u7a7a");if(!this.rect_data.acceptDesc||0===this.rect_data.acceptDesc.length)return void this.tools.showToast("\u8bf7\u8f93\u5165\u9a8c\u6536\u8bf4\u660e")}this.db.initDB().then(function(){l.db.insert("rect_accept_list",[l.rect_data],function(n){l.tools.showToast("\u4fdd\u5b58\u6210\u529f"),l.que.state_num="0"===l.rect_data.isPass?"20":"40",l.que.istate="1",l.db.initDB().then(function(){l.db.update(p.e,[l.que],function(n){var e={annex_type:"\u9a8c\u6536\u9644\u4ef6",isupdate:"0",problem_id:l.que.problem_id,record_date:i.a.getNowFormatDate(),record_desc:"\u9a8c\u6536",record_id:"",record_man:l.que.correct_manname+"->"+i.a.getManName(),record_type:"\u95ee\u9898\u9a8c\u6536",record_unit:l.rect_data.acceptDesc,table_id:""};l.db.initDB().then(function(){l.db.insert(p.g,[e],function(n){l.events.publish("que.op","0")})})})}),l.navCtrl.back()})}),console.log(this.rect_data)},l}(),m=function(){return function(){}}(),h=e("pMnS"),f=e("NAMV"),_=e("niVF"),C=e("4PO/"),v=e("oBZk"),b=e("gIcY"),D=e("ESoL"),y=e("R3V5"),x=t["\u0275crt"]({encapsulation:0,styles:[['@charset "UTF-8";.item_title[_ngcontent-%COMP%]{margin-left:15px;margin-top:17px;color:#000;font-size:16px;float:left}.item_content[_ngcontent-%COMP%]{margin-top:16px;margin-right:15px;color:#696969;font-size:16px;float:right}.item_layout[_ngcontent-%COMP%]{height:60px;margin:auto}input[type=radio][_ngcontent-%COMP%]{display:none}input[type=radio][_ngcontent-%COMP%] + span[_ngcontent-%COMP%]{display:inline-block;width:55px;height:30px;font-size:14px;color:gray;line-height:30px;text-align:center;margin-left:12px;background-color:#e0e0e0;border-radius:5px}input[type=radio][_ngcontent-%COMP%]:checked + span[_ngcontent-%COMP%]{color:#fff;background-color:#e75a16}.div_style[_ngcontent-%COMP%]{display:inline-block}.form-group[_ngcontent-%COMP%]{display:flex;padding:10px 15px}.form-group[_ngcontent-%COMP%]   .form-label[_ngcontent-%COMP%]{flex:0 0 80px}.form-group[_ngcontent-%COMP%]   .form-control[_ngcontent-%COMP%]{flex:1}.splitor[_ngcontent-%COMP%]{height:5px;background:#f8f8f8}']],data:{}});function M(l){return t["\u0275vid"](0,[(l()(),t["\u0275eld"](0,0,null,null,11,"ion-header",[],null,null,null,v.T,v.n)),t["\u0275did"](1,49152,null,0,a.IonHeader,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],null,null),(l()(),t["\u0275eld"](2,0,null,0,9,"ion-toolbar",[["color","primary"]],null,null,null,v.kb,v.E)),t["\u0275did"](3,49152,null,0,a.IonToolbar,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],{color:[0,"color"]},null),(l()(),t["\u0275eld"](4,0,null,0,4,"ion-buttons",[["slot","start"]],null,null,null,v.J,v.d)),t["\u0275did"](5,49152,null,0,a.IonButtons,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],null,null),(l()(),t["\u0275eld"](6,0,null,0,2,"ion-back-button",[["default-href","home"]],null,[[null,"click"]],function(l,n,e){var o=!0;return"click"===n&&(o=!1!==t["\u0275nov"](l,8).onClick(e)&&o),o},v.H,v.b)),t["\u0275did"](7,49152,null,0,a.IonBackButton,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],null,null),t["\u0275did"](8,16384,null,0,a.IonBackButtonDelegate,[[2,a.IonRouterOutlet],a.NavController],null,null),(l()(),t["\u0275eld"](9,0,null,0,2,"ion-title",[],null,null,null,v.jb,v.D)),t["\u0275did"](10,49152,null,0,a.IonTitle,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],null,null),(l()(),t["\u0275ted"](-1,0,["\u95ee\u9898\u9a8c\u6536"])),(l()(),t["\u0275eld"](12,0,null,null,38,"ion-content",[],null,null,null,v.P,v.j)),t["\u0275did"](13,49152,null,0,a.IonContent,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],null,null),(l()(),t["\u0275eld"](14,0,null,0,36,"form",[["novalidate",""]],[[2,"ng-untouched",null],[2,"ng-touched",null],[2,"ng-pristine",null],[2,"ng-dirty",null],[2,"ng-valid",null],[2,"ng-invalid",null],[2,"ng-pending",null]],[[null,"submit"],[null,"reset"]],function(l,n,e){var o=!0;return"submit"===n&&(o=!1!==t["\u0275nov"](l,16).onSubmit(e)&&o),"reset"===n&&(o=!1!==t["\u0275nov"](l,16).onReset()&&o),o},null,null)),t["\u0275did"](15,16384,null,0,b["\u0275angular_packages_forms_forms_bh"],[],null,null),t["\u0275did"](16,4210688,null,0,b.NgForm,[[8,null],[8,null]],null,null),t["\u0275prd"](2048,null,b.ControlContainer,null,[b.NgForm]),t["\u0275did"](18,16384,null,0,b.NgControlStatusGroup,[[4,b.ControlContainer]],null,null),(l()(),t["\u0275eld"](19,0,null,null,11,"div",[["class","item_layout"],["id","check_layout_1"]],null,null,null,null,null)),(l()(),t["\u0275eld"](20,0,null,null,1,"span",[["class","item_title"]],null,null,null,null,null)),(l()(),t["\u0275ted"](-1,null,["\u9a8c\u6536\u7ed3\u679c"])),(l()(),t["\u0275eld"](22,0,null,null,8,"div",[["display","inline"],["style","float:right;margin-right: 15px;line-height: 60px"]],null,null,null,null,null)),(l()(),t["\u0275eld"](23,0,null,null,3,"label",[["tappable",""]],null,[[null,"click"]],function(l,n,e){var t=!0;return"click"===n&&(t=!1!==l.component.isPass("1")&&t),t},null,null)),(l()(),t["\u0275eld"](24,0,null,null,0,"input",[["checked","checked"],["name","ispass"],["type","radio"]],null,null,null,null,null)),(l()(),t["\u0275eld"](25,0,null,null,1,"span",[],null,null,null,null,null)),(l()(),t["\u0275ted"](-1,null,["\u5408\u683c"])),(l()(),t["\u0275eld"](27,0,null,null,3,"label",[["tappable",""]],null,[[null,"click"]],function(l,n,e){var t=!0;return"click"===n&&(t=!1!==l.component.isPass("0")&&t),t},null,null)),(l()(),t["\u0275eld"](28,0,null,null,0,"input",[["name","ispass"],["type","radio"]],null,null,null,null,null)),(l()(),t["\u0275eld"](29,0,null,null,1,"span",[],null,null,null,null,null)),(l()(),t["\u0275ted"](-1,null,["\u4e0d\u5408\u683c"])),(l()(),t["\u0275eld"](31,0,null,null,0,"hr",[["style","height:1px;border:none;border-top:1px solid rgb(214, 214, 214);margin-left: 15px;margin-right: 15px;margin-top: 0px;margin-bottom: 0px"]],null,null,null,null,null)),(l()(),t["\u0275eld"](32,0,null,null,5,"div",[["class","form-group"]],null,null,null,null,null)),(l()(),t["\u0275eld"](33,0,null,null,1,"span",[["class","form-label"]],null,null,null,null,null)),(l()(),t["\u0275ted"](-1,null,["\u4e0a\u4f20\u9644\u4ef6"])),(l()(),t["\u0275eld"](35,0,null,null,2,"div",[["class","form-control"]],null,null,null,null,null)),(l()(),t["\u0275eld"](36,0,null,null,1,"app-image-uploader",[],null,[[null,"fileSelected"]],function(l,n,e){var t=!0;return"fileSelected"===n&&(t=!1!==l.component.fileSelected(e)&&t),t},D.b,D.a)),t["\u0275did"](37,114688,null,0,y.a,[a.ModalController,c.a,a.AlertController],{images:[0,"images"]},{fileSelected:"fileSelected"}),(l()(),t["\u0275eld"](38,0,null,null,0,"div",[["class","splitor"]],null,null,null,null,null)),(l()(),t["\u0275eld"](39,0,null,null,1,"div",[["style","margin-left:15px;margin-top:15px"]],null,null,null,null,null)),(l()(),t["\u0275ted"](-1,null,["\u9a8c\u6536\u8bf4\u660e"])),(l()(),t["\u0275eld"](41,0,null,null,8,"ion-item",[["style","margin-right:15px"]],null,null,null,v.Y,v.s)),t["\u0275did"](42,49152,null,0,a.IonItem,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],null,null),(l()(),t["\u0275eld"](43,0,null,0,6,"ion-textarea",[["id","que_comment"],["name","rectDesc"],["placeholder","\u8bf7\u8f93\u5165\u9a8c\u6536\u8bf4\u660e"],["rows","3"],["style","font-size:16px;color:dimgray;padding-left:2px;border: 1px solid rgb(214, 214, 214);margin-bottom:15px;margin-top: 15px;"]],[[2,"ng-untouched",null],[2,"ng-touched",null],[2,"ng-pristine",null],[2,"ng-dirty",null],[2,"ng-valid",null],[2,"ng-invalid",null],[2,"ng-pending",null]],[[null,"ngModelChange"],[null,"ionBlur"],[null,"ionChange"]],function(l,n,e){var o=!0,u=l.component;return"ionBlur"===n&&(o=!1!==t["\u0275nov"](l,44)._handleBlurEvent(e.target)&&o),"ionChange"===n&&(o=!1!==t["\u0275nov"](l,44)._handleInputEvent(e.target)&&o),"ngModelChange"===n&&(o=!1!==(u.rectData.rectDesc=e)&&o),o},v.ib,v.C)),t["\u0275did"](44,16384,null,0,a.TextValueAccessor,[t.ElementRef],null,null),t["\u0275prd"](1024,null,b.NG_VALUE_ACCESSOR,function(l){return[l]},[a.TextValueAccessor]),t["\u0275did"](46,671744,null,0,b.NgModel,[[2,b.ControlContainer],[8,null],[8,null],[6,b.NG_VALUE_ACCESSOR]],{name:[0,"name"],model:[1,"model"]},{update:"ngModelChange"}),t["\u0275prd"](2048,null,b.NgControl,null,[b.NgModel]),t["\u0275did"](48,16384,null,0,b.NgControlStatus,[[4,b.NgControl]],null,null),t["\u0275did"](49,49152,null,0,a.IonTextarea,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],{name:[0,"name"],placeholder:[1,"placeholder"],rows:[2,"rows"]},null),(l()(),t["\u0275eld"](50,0,null,null,0,"div",[["id","register_layout"]],null,null,null,null,null)),(l()(),t["\u0275eld"](51,0,null,null,4,"ion-footer",[],null,null,null,v.R,v.l)),t["\u0275did"](52,49152,null,0,a.IonFooter,[t.ChangeDetectorRef,t.ElementRef,t.NgZone],null,null),(l()(),t["\u0275eld"](53,0,null,0,2,"div",[],null,null,null,null,null)),(l()(),t["\u0275eld"](54,0,null,null,1,"button",[["id","submit_btn"],["style","color:white;width: 100%;height: 45px;background-color: rgb(231,90,22);font-size: 14px;  "],["tappable",""]],null,[[null,"click"]],function(l,n,e){var t=!0;return"click"===n&&(t=!1!==l.component.saveData()&&t),t},null,null)),(l()(),t["\u0275ted"](-1,null,["\u4fdd\u5b58"]))],function(l,n){var e=n.component;l(n,3,0,"primary"),l(n,37,0,e.rectData.images),l(n,46,0,"rectDesc",e.rectData.rectDesc),l(n,49,0,"rectDesc","\u8bf7\u8f93\u5165\u9a8c\u6536\u8bf4\u660e","3")},function(l,n){l(n,14,0,t["\u0275nov"](n,18).ngClassUntouched,t["\u0275nov"](n,18).ngClassTouched,t["\u0275nov"](n,18).ngClassPristine,t["\u0275nov"](n,18).ngClassDirty,t["\u0275nov"](n,18).ngClassValid,t["\u0275nov"](n,18).ngClassInvalid,t["\u0275nov"](n,18).ngClassPending),l(n,43,0,t["\u0275nov"](n,48).ngClassUntouched,t["\u0275nov"](n,48).ngClassTouched,t["\u0275nov"](n,48).ngClassPristine,t["\u0275nov"](n,48).ngClassDirty,t["\u0275nov"](n,48).ngClassValid,t["\u0275nov"](n,48).ngClassInvalid,t["\u0275nov"](n,48).ngClassPending)})}function P(l){return t["\u0275vid"](0,[(l()(),t["\u0275eld"](0,0,null,null,1,"app-rect-accept",[],null,null,null,M,x)),t["\u0275did"](1,114688,null,0,g,[d.a,u.a,a.ModalController,c.a,a.NavController,a.Events],null,null)],function(l,n){l(n,1,0)},null)}var R=t["\u0275ccf"]("app-rect-accept",g,P,{},{},[]),I=e("Ip0R"),k=e("ZYCi"),N=e("l4Sw"),O=e("j1ZV"),w=e("9LwV"),E=e("PdO7");e.d(n,"RectAcceptPageModuleNgFactory",function(){return q});var q=t["\u0275cmf"](m,[],function(l){return t["\u0275mod"]([t["\u0275mpd"](512,t.ComponentFactoryResolver,t["\u0275CodegenComponentFactoryResolver"],[[8,[h.a,f.a,_.a,C.a,R]],[3,t.ComponentFactoryResolver],t.NgModuleRef]),t["\u0275mpd"](4608,I.NgLocalization,I.NgLocaleLocalization,[t.LOCALE_ID,[2,I["\u0275angular_packages_common_common_a"]]]),t["\u0275mpd"](4608,b["\u0275angular_packages_forms_forms_j"],b["\u0275angular_packages_forms_forms_j"],[]),t["\u0275mpd"](4608,a.AngularDelegate,a.AngularDelegate,[t.NgZone,t.ApplicationRef]),t["\u0275mpd"](4608,a.ModalController,a.ModalController,[a.AngularDelegate,t.ComponentFactoryResolver,t.Injector]),t["\u0275mpd"](4608,a.PopoverController,a.PopoverController,[a.AngularDelegate,t.ComponentFactoryResolver,t.Injector]),t["\u0275mpd"](1073742336,I.CommonModule,I.CommonModule,[]),t["\u0275mpd"](1073742336,b["\u0275angular_packages_forms_forms_bc"],b["\u0275angular_packages_forms_forms_bc"],[]),t["\u0275mpd"](1073742336,b.FormsModule,b.FormsModule,[]),t["\u0275mpd"](1073742336,a.IonicModule,a.IonicModule,[]),t["\u0275mpd"](1073742336,k.n,k.n,[[2,k.t],[2,k.m]]),t["\u0275mpd"](1073742336,N.a,N.a,[]),t["\u0275mpd"](1073742336,O.a,O.a,[]),t["\u0275mpd"](1073742336,w.a,w.a,[]),t["\u0275mpd"](1073742336,E.a,E.a,[]),t["\u0275mpd"](1073742336,m,m,[]),t["\u0275mpd"](1024,k.k,function(){return[[{path:"",component:g}]]},[])])})}}]);