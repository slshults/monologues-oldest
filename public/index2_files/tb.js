/* TweetBoard */
function TweetBoardPre() {
this.msgcount = -1;
this.cfg = {
	tburl:'http://tweetboard.com/',
	tbimgurl:'http://static.tweetboard.com/',
	src: '',
	user:'',
	sbase:'',
	sdom:'',
	clist:'',
	ishost:false,
	ispvt :false,
	maint :false,
	hasstyle:false,
	hasctab:false,
	uid:0,
	siteid:0
};

this.flags = {
	disabled:false,
	pinit: false,
	bookmarklet:false,
	wid: '_wtb',
	ismobile:false,
	nodoctype:false,
	isie6:false,
	ismin:false,
	resize_start:0,
	resize_pos:0,
	loaded:0,
	pmprocess:true,
	cinit:false,
	ticktime1:150,
	ticktime2:15,
	wtype:0,
	icontype:0,
	expand:0,
	lupdate:0,
	cupdates:0,
	ltimer:0,
	ltimer2:0,
	ltimer3:0,
	lg:0
};
this.wpos     = {
	animated: false,
	visible : false,
	wwidth  : 420,
	wheight : 160,
	wminwidth: 290,
	target  : 0,
	ohash : '',
	stime : 0,
	ttime : 0
	};
this.cursrc   = '';

this.init = function ()
{
    var allscripts = document.getElementsByTagName('script');
    for(var si in allscripts)
    if(allscripts[si].src && allscripts[si].src.indexOf('/tb.js') > 0)
    	this.cfg['src'] = allscripts[si].src;
   

	var usr = this.cfg['src'].replace(/^.+user=([^&]+).*$/, '$1');
    if((typeof _tbdef != 'undefined') && (_tbdef['user']))
    {
    	usr = _tbdef['user'];
    }
	if(usr == this.cfg['src'])
		usr = this.cfg['src'].replace(/^.+\/([^\/]+)\/tb\.js.*/, '$1');
	if(usr == this.cfg['src'])
		usr = '';
	this.cfg['user'] = usr;
	
   if(this.gel(this.wname('tb_wcont')))
   	   return false;

   var lhash = document.location.hash;
   var setcookie = '';
   if(lhash.indexOf('tboard_off') >= 0)
   		setcookie = "tboard_off=yes";
   if(lhash.indexOf('tboard_on') >= 0)
   		setcookie = "tboard_off=";
   	   
   this.flags['isie6'] = (navigator.userAgent.indexOf('MSIE 6') >= 0);
   if(navigator.userAgent.indexOf('MSIE') >= 0)
   if(this.flags['isie6'] || (document.firstChild.nodeValue == null))
   		this.flags['nodoctype'] = true;

   if(setcookie)
   {
   		var expire = new Date();
   		expire.setFullYear(expire.getFullYear() + 1);
   		document.cookie = setcookie + "; expires=" + expire.toGMTString() + "; path=/";
   }

   if(document.cookie.indexOf("tboard_off=yes") < 0)
   {
   		if(lhash.substring(1,7) == 'tboard' || this.flags['bookmarklet'])
   	 		this.flags['expand'] = 1;

   		this.icon_insert();
        if(this.flags['nodoctype'])
            this.gel(this.wname('tb_wcont')).style.position = 'absolute';
   }else
   		this.flags['disabled'] = true;
};

this.init_pos = function (tic, shift)
{
     tic.style.left = this.flags['bookmarklet'] ? '50%' : '-'+(this.wpos['wwidth'] - shift)+'px';
     tic.style.top = this.flags['bookmarklet'] ? '-'+(this.wpos['wheight'])+'px' : '0px';
     tic.className += (this.flags['bookmarklet'] ? ' tb_bookmarklet':'')+' tb_slide';
};

this.init_content = function (tp)
{
   var d = document;
   this.flags['cinit'] = true;
   if(!this.gel(this.wname('tb_cont')) )
   {
     var tic = d.createElement('iframe');
     tic.id = this.wname('tb_cont');
     tic.name = this.wname('tb_cont');
     tic.className = 'tb_content';
     this.init_pos(tic, 10);
     tic.style.display = 'none';
     if(this.flags['nodoctype'])
      	tic.style.position = 'absolute';
   	if(this.flags['isie6'])
   		tic.style.height = document.documentElement.clientHeight;
     tic.src = this.if_src(tp);
     tic.scrolling = 'no';
     tic.frameBorder = 0;
     tic.setAttribute("allowTransparency","true");
     this.add_el(tic);

	 return true;
   }
   return false;
};

this.init_onload = function ()
{
   if(this.flags['loaded'])
   	return;

   this.flags['loaded']++;

   var d = document;
   if(!this.gel(this.wname('tb_wcont')))
   	 this.init();

   if(this.flags['disabled'])
   	 return;


   this.set_timer(1);
};

this.init_params = function ()
{
   this.flags['pinit'] = true;
   this.change_class(this.wname('tb_wcont'), 'tb_sponsor', this.cfg['hasctab']);
   if(this.flags['expand'])
   {
     this.flags['expand'] = 0;
     this.icon_click();
   }else
   {
      }
};

this.slide_prop = function (el, setto)
{
	if(typeof setto == 'undefined')
	    return parseInt(this.flags['bookmarklet'] ? el.style.top : el.style.left);
    else
    {
    	if(this.flags['bookmarklet'])
    		el.style.top = setto;
    	else
    		el.style.left = setto;
    }
};

this.check_timer = function ()
{

  var curtime = this.ctime();
  this.cmd_dispatch();

  if(!this.flags['cinit'] && ((curtime - this.flags['ltimer2']) > 60000) )
  {
  	this.flags['ltimer2'] = curtime;
  	tb_pre_wtb.count_timer();
  }
  if(this.wpos['animated'])
  {             
    var ael = [this.wname('tb_cont'), this.wname('tb_over')];
    
    if(!this.flags['bookmarklet'])
    	ael[ael.length] = this.wname('tb_wcont');
    
    var tdiff = curtime - this.wpos['stime'];
    var pshift = 1;
    if(tdiff >= this.wpos['ttime'])
    {
    	this.set_timer(1);
      	this.wpos['animated'] = false;
      	if(!this.wpos['visible'])
      	{
      		this.change_class(this.wname('tb_wcont'), 'tb_open', false);
      	}
		this.wswitch_state(this.wpos['visible']);
  		this.cmd_send('open_' + (this.wpos['visible']?1:0));

  		      	document.location.hash = this.wpos['visible'] ? '#tboard' : '#tb';
      	    }else
    	pshift = tdiff/this.wpos['ttime'];

    pshift = ((-Math.cos(pshift * Math.PI)/2) + 0.5) * this.wpos['target'];
                
    for(var i=0;i<ael.length;i++)
    if(this.gel(ael[i]))
    {
    	el = ael[i];
    	
    	if(typeof this.epos[el] == 'undefined')
    	{
	  		this.epos[el] = this.slide_prop(this.gel(el));
	  		if(isNaN(this.epos[el]))
	  			this.epos[el] = 0;
        }
        this.slide_prop(this.gel(el), this.epos[el] + pshift +  'px');
    }
  }
};

this.count_timer = function ()
{
	this.flags['cupdates']++;

	if(this.flags['cupdates']>1)
		return;
	if((this.flags['cupdates']>3) && (this.flags['cupdates']%30 != 0))
		return;

	this.jsload('widget/tb.counter.js?user='+encodeURIComponent(this.cfg['user'])+'&cupdates='+this.flags['cupdates']+'&validate=now&lu='+this.flags['lupdate']+'&tbpre=tb_pre_wtb&r='+Math.random(),
		'tb_js_counter', true);
   
};

this.wswitch = function ()
{
   this.wswitch_state(!this.wpos['visible']);
};

this.wswitch_state = function (state)
{
  
  if(state || (this.wpos['visible'] == state))
  {
  this.change_class('tb_passive_small', 'tb_active', state && (this.flags['wtype']==1));
  this.change_class('tb_passive_tweet', 'tb_active', state && (this.flags['wtype']==0));
  this.change_class('tb_passive_large', 'tb_active', state && (this.flags['wtype']==0));
  }
  if(this.wpos['visible'] == state)
    return;


  if(!this.wpos['animated'])
  {
    this.set_timer(2);
    this.wpos['visible'] = state;
    this.wpos['target'] = this.flags['bookmarklet'] ? this.wpos['wheight'] : this.wpos['wwidth'];
    if(!state)
    	this.wpos['target'] = -this.wpos['target'];
    this.wpos['stime'] = this.ctime();
    this.wpos['ttime'] = 500;
    
    this.epos = {};
    this.wpos['animated'] = true;

    if(this.wpos['visible'])
  		this.change_class(this.wname('tb_wcont'), 'tb_open', true);
  }

}

this.cmd_dispatch = function()
{	
   var cmdpos = document.location.hash.indexOf('tbcmd_');
   if(cmdpos >= 0)
   {
   	var cmd = document.location.hash.substring(cmdpos+6);
   	document.location.hash = this.wpos['ohash'] ? this.wpos['ohash'] : '#';
   	this.cmd_get(cmd);
   }
   if(this.wpos['ohash'] != document.location.hash)
	   this.wpos['ohash'] = document.location.hash;
};

this.cmd_get = function(e)
{	
	if(e && e.data) 
		e = e.data;

    var psplit = (typeof e == 'string') ? e.split('_') : [''];
    var cmd = psplit[0];

    if(cmd.indexOf('wtb') == 0)
    	cmd = cmd.substring(3);

	switch(cmd)
	{
	case 'ready':
	window.clearTimeout(this.flags['ltimer3']);
  	this.change_class(this.wname('tb_wcont'), 'tb_n_load', false);
	this.wswitch_state(true);
	this.gel(this.wname('tb_cont')).style.display = '';
	break;
	
	case 'count':
	if(psplit[3])
		this.flags['lupdate'] = psplit[3];
	this.icon_update(psplit[1],psplit[2]);
	break;

	case 'countinc':
	this.icon_update(this.msgcount+1,0);
	break;

	case 'gohome':
	var tu = this.cfg['sbase']+'#tboard';
	if(document.location == tu)
		document.location.reload();
	else
		document.location = tu;
		
	break;

	case 'close':
	this.wswitch_state(false);
	break;

	}
};

this.cmd_send = function(cmd)
{	
    this.gel(this.wname('tb_cont')).src = this.cursrc + '&cmdtb_' + cmd+'_'+this.flags['wtype'];
};

this.if_src = function(inum)
{
    var isrc = this.cfg['tburl'] + "widget/if-0.1.58" + (inum?"-"+inum:"") + (this.flags['bookmarklet']?'.b':'')+(this.cfg['maint']?'.m':'')+'.e'+(this.cfg['hasstyle']?'.s':'')+'.html';

	this.ifsrc  = "#user="+encodeURIComponent(this.cfg['user'])+"&username="+encodeURIComponent(this.cfg['user'])+"&siteid="+this.cfg['siteid']+"&hash="+encodeURIComponent(document.location.hash)+"&href="+encodeURIComponent(document.location.href)+"&sdom="+encodeURIComponent(this.cfg['sdom']);
	this.ifsrc += "&sbase="+encodeURIComponent(this.cfg['sbase'])+"&clist="+encodeURIComponent(this.cfg['clist'])+"&uid="+this.cfg['uid']+"&ishost="+this.cfg['ishost']+"&ispvt="+this.cfg['ispvt']+"&wid="+this.flags['wid'];
	
	isrc += this.ifsrc + '&msgcount=' + this.msgcount + '&wtype='+this.flags['wtype'] + '&ismin='+(this.flags['ismin']?1:0) ;

	this.cursrc = isrc;
	return isrc;
};

this.home_click = function ()
{
   return this.icon_click_t(1);
};

this.icon_click = function ()
{
   return this.icon_click_t(0);
};

this.icon_click_t = function (wtype)
{
	if(!this.flags['pinit']) return false;

    var d = document;
    var wchanged = (wtype != this.flags['wtype']);
    this.flags['wtype'] = wtype;
    this.set_widget_width(this.wpos['wwidth'], false);

   	var cinit = this.init_content('');
	if(!this.gel(this.wname('tb_over')))
	{
  		this.change_class(this.wname('tb_wcont'), 'tb_n_load', true);

        var tic = d.createElement('div');
        
        tic.id = this.wname('tb_over');
        tic.className = 'tb_overlay';
        this.init_pos(tic, 0);
        if(this.flags['nodoctype'])
        	tic.style.position = 'absolute';
     	this.add_el(tic);
     	if(this.flags['isie6'])
     		tic.style.height = document.documentElement.clientHeight;

        //d.body.appendChild(tic);
        
        var tic2 = d.createElement('a');
        tic2.id = 'tb_resizer';
        tic2.onmousedown = function(ev)
        {
        	if(typeof ev == 'undefined')
        		ev = window.event;
        	tb_pre_wtb.flags['resize_pos'] = ev.clientX;
        	tb_pre_wtb.flags['resize_start'] = tb_pre_wtb.wpos['wwidth'];

            var tic = d.createElement('div');
            
            tic.id = tb_pre_wtb.wname('tb_over2');
            tic.className = 'tb_slide';
            tic.style.left = '0px';
            tic.style.width = '100%';
            tic.style.position = 'fixed';
            tic.style.height = tb_pre_wtb.flags['isie6'] ? document.documentElement.clientHeight : '100%';
            tic.style.zIndex = '2000000001';
         	tb_pre_wtb.add_el(tic);
        	return false;
        };
        
        this.add_event('mouseup', function()
        {
        	var ov2id = tb_pre_wtb.gel(tb_pre_wtb.wname('tb_over2'));
        	if(ov2id) document.body.removeChild(ov2id);
        	tb_pre_wtb.flags['resize_start']=0;
        	return false;
        }, false);
		this.add_event('mousemove', tb_pre_wtb.resize_move, false);
        
        tic2.href = '#';
        tic.appendChild(tic2);

        if(!cinit)
	        this.gel(this.wname('tb_cont')).src = this.if_src('');
        
    	this.set_widget_width(this.wpos['wwidth'], false);
	}
	else
	{
	  if((this.msgcount > 0) || wchanged)
	  {
	    this.cmd_send('load_' + this.msgcount);
	    tb_pre_wtb.wswitch_state(true);
	  }else
	  {
	    tb_pre_wtb.wswitch();
	  }
	}

	
	return false;
};

this.gel = function (elid)
{
	return document.getElementById(elid);
};

this.wname = function (elid)
{
	return elid+'_wtb';
};

this.set_digit_style = function (eln, digit)
{
	this.gel('tb_n_'+eln).style.background = (digit||(eln==2)) ? 'url('+this.cfg['tburl']+'widget/images/notifier/'+digit+'.png) no-repeat' : '';
};

this.icon_update = function (msgcount, lv)
{
  
	this.flags['ltimer2'] = this.ctime();

	msgcount = parseInt(msgcount);
	if(this.msgcount != msgcount)
	{
    	this.msgcount = msgcount;

   		this.gel('tb_passive_count').className = 'tb_passive_'+(msgcount.toString().length)+'n';
   		this.gel('tb_passive_count').innerHTML = msgcount;
		this.gel('tb_passive_count').style.display = msgcount ? '' : 'none';

        this.gel(this.wname('tb_wcont')).style.display = '';
	}
		
};

this.icon_insert = function ()
{

   var d = document;
   this.cssload(".tb_passive_container { 	bottom:0; 	padding:0px; 	margin:0px; 	position:fixed; 	top:35%; 	cursor:pointer; 	left:0px; 	padding:0px; 	margin:0px; 	height: 101px; 	z-index:2000000000; 	background:none; 	line-height:normal; } 	 .tb_passive_container.tb_sponsor {   height: 145px; } .tb_passive_container.tb_bookmarklet { 	display:none; } #tb_passive_t {   width:22px;   height:27px;   position:absolute;   left:4px;   bottom: 10px;   z-index:1;   display:none; } .tb_passive_container.tb_sponsor #tb_passive_t {   background:transparent url(http://static.tweetboard.com/widget/images/t.png) 0px 0px no-repeat;   display:block; } #tb_passive_tweet { 	background:transparent url(http://static.tweetboard.com/widget/images/passive_tweets.png) 0px 0px no-repeat; 	width:14px; 	height:63px; 	position:absolute; 	left:13px; 	top: 19px; 	z-index:1; } #tb_passive_count { 	background-color:#FF0000;     box-shadow: 0 1px 2px #999;     -webkit-box-shadow: #999 0 1px 2px;     -moz-box-shadow: 0 1px 2px #999;     filter: progid:DXImageTransform.Microsoft.dropShadow(color=#999999, offX=0, offY=1, Positive=true); 	top:-3px; 	color:#FFFFFF; 	font-family:\"lucida grande\",tahoma,verdana,arial,sans-serif; 	font-size:11px; 	font-weight:bold; 	text-decoration:none; 	text-transform:none; 	letter-spacing:0px; 	font-stretch:normal; 	position:absolute; 	margin:0;     padding:1px 5px;     -moz-border-radius:8px;     -webkit-border-radius:8px; 	line-height:normal; 	text-align:left; 	z-index:2; } .tb_passive_1n {     left:20px;     padding:1px 5px !important; } .tb_passive_2n { 	left:15px; 	padding:1px 4px !important; } .tb_passive_3n { 	left:10px; 	padding:1px 4px !important; } #tb_passive_small { 	position:absolute; 	bottom:0px; 	left:0px; 	height:44px; 	width:38px; 	border: none; 	margin:0; 	padding:0; 	opacity:.95; 	display:none; } .tb_passive_container.tb_sponsor #tb_passive_small {     display:block; 	background:transparent url(http://static.tweetboard.com/widget/images/passive_sponsor_tab.png) 0px 0px no-repeat; } #tb_passive_large {     position:absolute;     top:0px; 	left:0px; 	height:101px; 	width:38px; 	border: none; 	margin:0; 	padding:0; 	background:transparent url(http://static.tweetboard.com/widget/images/passive_tab.png) 0px 0px no-repeat; 	opacity:.95; } .tb_passive_container.tb_open #tb_passive_tweet { 	left:8px; } .tb_passive_container.tb_sponsor #tb_passive_tweet {     left:8px;     background-image:url(http://static.tweetboard.com/widget/images/passive_sponsor_tweets.png);     background-position: 0 -101px; } .tb_passive_container.tb_sponsor #tb_passive_tweet.tb_active {     background-position: 0 0; } .tb_passive_container.tb_open .tb_passive_1n, .tb_passive_container.tb_sponsor .tb_passive_1n { 	left:15px; } .tb_passive_container.tb_open .tb_passive_2n, .tb_passive_container.tb_sponsor .tb_passive_2n {     left:10px; } .tb_passive_container.tb_open .tb_passive_3n, .tb_passive_container.tb_sponsor .tb_passive_3n {     left:5px; } .tb_passive_container.tb_sponsor #tb_passive_small {     background-position: -5px -44px !important; } .tb_passive_container #tb_passive_small.tb_open {     background-position: -5px -88px !important; } .tb_passive_container.tb_sponsor #tb_passive_small.tb_active {     background-position: -5px 0 !important; } #tb_passive_large.tb_open { 	background-position: 0px -101px !important; } .tb_passive_container.tb_open #tb_passive_large { 	background-position: -5px -202px !important; } .tb_passive_container.tb_open #tb_passive_large.tb_open { 	background-position: -5px -303px !important; } .tb_passive_container.tb_sponsor #tb_passive_large {     background-image:url(http://static.tweetboard.com/widget/images/passive_sponsor_tab.png);     background-position: -5px -233px !important; } .tb_passive_container.tb_sponsor #tb_passive_large.tb_open {     background-position: -5px -334px !important; } .tb_passive_container.tb_sponsor #tb_passive_large.tb_active {     background-position: -5px -132px !important; } .tb_overlay { 	width: 420px; 	min-width:289px; 	z-index: 1000000000; 	opacity:0.95; 	background-color:#333333; 	border-right:#333 1px solid ; 	position: fixed; 	top: 0px; 	left:-420px; 	padding:0px; 	margin:0px; 	height: 100%; } .tb_overlay.tb_bookmarklet {     left:50%;     margin-left:-210px;     height:159px;     border:1px solid #222222;    -moz-border-radius-bottomleft:10px;    -moz-border-radius-bottomright:10px;    -webkit-border-bottom-left-radius:10px;    -webkit-border-bottom-right-radius:10px; } #tb_resizer {     position:absolute;     background-image:url(http://static.tweetboard.com/widget/images/dots.png);     width:7px;     height:60px;     right:1px;     top: 48%;     cursor:e-resize; } .tb_bookmarklet #tb_resizer {    display:none; } .tb_content { 	z-index: 2000000000; 	margin: 0px;  	padding: 0px;  	position: fixed;  	width: 400px; 	scrolling: no; 	min-width:269px; 	top: 0px; 	left:-410px; 	height: 100%;  	border:none; } .tb_content.tb_bookmarklet {     left:50%;     margin-left:-200px;     height:159px; } #tb_waitload { 	display:none; 	position:absolute; 	top:39px; 	left:11px; } .tb_n_load { 	opacity:0.6; 	filter2: alpha(opacity=60); } .tb_n_load #tb_waitload { 	display:inline; } #tb_home { 	z-index:1000000000; 	top: -45px; 	position: absolute; } #tb_home img { 	border: none; } a:focus {   outline: none; }");
    
   if(!this.gel(this.wname('tb_wcont')))
   {
     var tic = d.createElement('div');
     tic.innerHTML = "<div id=\"tb_wcont_wtb\" class=\"tb_passive_container\"> <div id=\"tb_passive_small\" onclick=\"return tb_pre_wtb.home_click()\" onmouseover=\"tb_pre_wtb.icon_over('small')\" onmouseout=\"tb_pre_wtb.icon_out('small')\"></div> <div id=\"tb_passive_t\" onclick=\"return tb_pre_wtb.home_click()\" onmouseover=\"tb_pre_wtb.icon_over('small')\" onmouseout=\"tb_pre_wtb.icon_out('small')\"></div> <div onclick=\"return tb_pre_wtb.icon_click()\" onmouseover=\"tb_pre_wtb.icon_over('large')\" onmouseout=\"tb_pre_wtb.icon_out('large')\"> 	<div id=\"tb_passive_tweet\"></div>     <span id=\"tb_passive_count\" class=\"tb_passive_2n\" style=\"display:none\"></span>     <div id=\"tb_passive_large\"></div> </div> <img id=\"tb_waitload\" src=\"http://static.tweetboard.com/widget/images/ajax-loader.gif\" /> </div>";
     tic.id = 'TB_icon';
     tic.style.display = 'none';
     this.add_el(tic);
     if(this.flags['bookmarklet'])
         this.gel(this.wname('tb_wcont')).className += ' tb_bookmarklet';

     d.body.replaceChild(this.gel(this.wname('tb_wcont')), this.gel('TB_icon'));

     //this.icon_update(0,0);
   }   

   if(!this.add_event("message", function(e){ tb_pre_wtb.cmd_get(e); }, true))
   		this.flags['pmprocess'] = false;	
    
};

this.icon_over = function(tp)
{
  	this.change_class('tb_passive_'+tp, 'tb_open', true);
};

this.icon_out = function(tp)
{
  	this.change_class('tb_passive_'+tp, 'tb_open', false);
};

this.add_onload = function(fnc)
{   
  if(!this.add_event( 'load', fnc, true ))
  {                        
    if ( window.onload != null ) 
    {
      var oldOnload = window.onload;
      window.onload = function ( e ) 
      {
        oldOnload(e);
        window[fnc]();
      };
    }
    else
      window.onload = fnc;
  }
};

this.change_class = function (elid, cname, onoff) 
{
	var el = this.gel(elid);
	if(onoff && (onoff!=0))
	{
		if(el.className.indexOf(cname)<0)
			el.className += ' '+cname;
	}else
	{
		for(var cn='';cn!=el.className;)
		{
			cn = el.className;
			el.className = el.className.replace(cname,'');
		}
		el.className = el.className.replace(/ +/g, ' ');
	}
};

this.add_el = function (tic)
{
   var b = document.body;
   try {
    if(b.childNodes.length > 0)
   		b.insertBefore(tic, b.childNodes[0]);
   	else
   		b.appendChild(tic);
   }catch(e) {

   	return false;
   }
   
   return true;
};

this.set_timer = function (tp) 
{
   if(this.flags['ltimer'])
	   window.clearInterval(this.flags['ltimer']);
   
   this.flags['ltimer'] = null;
   this.flags['ltimer'] = window.setInterval('tb_pre_wtb.check_timer()', this.flags['ticktime'+tp]);
};

this.cssload = function (cssText)
{
   var d = document;
    
   var styleText = d.createTextNode(cssText);
   var styleNode = d.createElement("style");
   styleNode.type = 'text/css';
   if(styleNode.styleSheet)
	  styleNode.styleSheet.cssText = styleText.nodeValue;
	   else
   	  styleNode.appendChild(styleText);
   d.getElementsByTagName("head")[0].appendChild(styleNode);
};

this.jsload = function (jsurl, jsid, override)
{

   var d = document;
   var head = d.getElementsByTagName('head')[0];
   var u = this.cfg['tburl'] + jsurl;
   if(this.gel(jsid))
   {
     if(!override)
   	 	return false;
   	 else
     	head.removeChild(this.gel(jsid));
   }
   var s = d.createElement('script');
   s.type= 'text/javascript';
   s.src = u;
   s.id  = jsid;
   head.appendChild(s);
   return true;
};

this.add_event = function(ev, func, wnd)
{
   var scope = wnd ? window : document;
   if(typeof scope.addEventListener != 'undefined')
   {
   		scope.addEventListener(ev, func, false);
   }else
   if(typeof scope.attachEvent != 'undefined')
   {
   		scope.attachEvent('on'+ev, func);
   }else
   	return false;

   return true;
};

this.set_widget_width = function (wd, mv) 
{
	wd = Math.min(parseInt(document.body.clientWidth*0.9), wd);
	wd = Math.max(tb_pre_wtb.wpos['wminwidth'], wd);
	tb_pre_wtb.wpos['wwidth'] = wd;

	this.flags['ismin'] = (wd - tb_pre_wtb.wpos['wminwidth'] < 30);
    var e1 = tb_pre_wtb.gel(this.wname('tb_over'));
    var e2 = tb_pre_wtb.gel(this.wname('tb_cont'));
    if(e1 && e2)
    {
    	e1.style.width = (wd - 1) + 'px';
    	e2.style.width = (wd - 20)+ 'px';

    	if(parseInt(e1.style.left)<0) e1.style.left = '-'+(wd)+'px';
    	if(parseInt(e2.style.left)<0) e2.style.left = '-'+(wd-10)+'px';
    }

	if(mv)
	{
		this.gel(this.wname('tb_wcont')).style.left = (wd)+'px';
		this.cmd_send('state_' + (this.flags['ismin'] ?  'min' : 'max'));
	}

};

this.resize_move = function (ev)
{
	if(tb_pre_wtb.flags['resize_start'])
	{
		tb_pre_wtb.set_widget_width(
			tb_pre_wtb.flags['resize_start'] - tb_pre_wtb.flags['resize_pos'] + ev.clientX, true );
	}
	return false;
};

this.ctime = function(){ return +new Date;}

}

if(typeof tb_pre_wtb == 'undefined')
{
   var tb_pre_wtb = new TweetBoardPre();

   if(document.body)
   {
	   //tb_pre_wtb.init();
	   tb_pre_wtb.init_onload();
   }
   tb_pre_wtb.add_onload(function(){tb_pre_wtb.init_onload();});

}
