<html>
<head>
<title>
demo_post.php:  $_POST is not empty</title>
</head>
<body>

<h3>This is an unformatted, reflexive php demo intended to gradually build upon the HTTP Post method and the PHP $_POST variable.</h3>
<div id="main">

Your fake name is John Smith
<h4>Enter a fake name:</h4>
<form action="demo_post.php" method="post">
<p>First name:<input type="text" name="fname" value='John' />
<p>Last name:<input type="text" name="lname" value='Smith' />
<p><input type="submit" name="submit" />
</form>
<p> No information entered is used or stored in any way, aside from being transferred over http to my hosting provider and back. Because http is insecure, it's best not to enter any personally identifiable information into this form.
</div>

</body>
</html>
