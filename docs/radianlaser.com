<!DOCTYPE html>
<html>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">


<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" type="text/css" href="/css/style.css">


<title>Radian Laser</title>


<body><header class="container bg-white">
    <nav class="navbar navbar-expand-lg navbar-light">
	<a class="navbar-brand text-muted text-monospace" href="/">rusty eddy</a>
	<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
	    <span class="navbar-toggler-icon"></span>
	</button>

	<div class="collapse navbar-collapse" id="navbarNavAltMarkup">
	    <nav class="navbar-nav">
		<div class="nav  justify-content-end">
  		    <a class="nav-link" href="/">home</a>
  	            <a class="nav-link" href="/notes">notes</a>
  	            <a class="nav-link" href="/resume">resume</a>
  	            <a class="nav-link" href="/projects">projects</a>
  	            <a class="nav-link" href="/contact">contact</a>
  	            <a class="nav-link" href="/about">about</a>
		</div>
 	    </nav>
	</div>

    </nav>
</header>
<div id="main"><div class="row">
    <div class="col"></div>
    <div class="col-md-8 hero-text">
	<article class="article">
	  <p>Responsible for the design, development and support of numerous
company software projects, including but not limited to control
systems firmware, single page apps for operational concerns.</p>
<p>Development involved C/C++, Go and Python primarily.  MicroServices
and distributed communication design where large parts of the work we
do.</p>

	</article>
    </div>
    <div class="col"></div>
</div>


	</div><footer id="footer" class="container mb-5 pb-5">
    <div class="row mt-5 pt-5">
	<div class="col-2"></div>
	<div class="col-8">
	  <span class="copyright">Eddy Consulting, LLC, Copyright 2006-2019</span>
	</div>
    </div>
</footer>

<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>


<script type="application/javascript">
var doNotTrack = false;
if (!doNotTrack) {
	window.ga=window.ga||function(){(ga.q=ga.q||[]).push(arguments)};ga.l=+new Date;
	ga('create', 'UA-19940083-13', 'auto');
	
	ga('send', 'pageview');
}
</script>
<script async src='https://www.google-analytics.com/analytics.js'></script>



<script type="text/javascript">
  var _dcq = _dcq || [];
  var _dcs = _dcs || {};
  _dcs.account = '9757293';

  (function() {
    var dc = document.createElement('script');
    dc.type = 'text/javascript'; dc.async = true;
    dc.src = '//tag.getdrip.com/9757293.js';
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(dc, s);
  })();
</script>



    <script data-no-instant>document.write('<script src="/livereload.js?port=1313&mindelay=10&v=2"></' + 'script>')</script></body>
</html>
