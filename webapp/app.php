#!/usr/bin/env php
<?php
$colors = file("php://fd/" . basename($argv[1]), FILE_IGNORE_NEW_LINES);
?>
<html>
	<head>
		<title>CSS Color Scheme Editor</title>

		<link rel="stylesheet" href="css/style.css">

		<script src="lib/angular.js"></script>

		<script src="js/app.js"></script>
		<script src="js/controllers.js"></script>
		<script src="js/services.js"></script>

		<script>
		var url = '<?php echo $argv[2]; ?>';

		var colors = {};
		<?php foreach ($colors as $color): ?>
		colors['<?php echo $color; ?>'] = '<?php echo $color; ?>';
		<?php endforeach; ?>
		</script>
	</head>
	<body data-ng-app="cseApp" data-ng-controller="cseCtrl">
		<?php
		foreach ($colors as $color):
		?>
		<div>
			<input 
				readonly
				type="text"
				style="background-color: <?php echo $color; ?>;"
				value="<?php echo $color; ?>">
			<input
				type="text"
				data-ng-model="colors['<?php echo $color; ?>']"
				data-ng-style="{'background-color': colors['<?php echo $color; ?>']}">
		</div>
		<?php
		endforeach;
		?>

		<div>
			<input readonly type="text" data-ng-model="message">
			<input type="button" value="Save" data-ng-click="save()">
		</div>
	</body>
</html>
