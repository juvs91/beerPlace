<?php
/* @var $this BeerController */
/* @var $model Beer */

$this->breadcrumbs=array(
	'Beers'=>array('index'),
	'Create',
);

$this->menu=array(
	array('label'=>'List Beer', 'url'=>array('index')),
	array('label'=>'Manage Beer', 'url'=>array('admin')),
);
?>

<h1>Create Beer</h1>

<?php echo $this->renderPartial('_form', array('model'=>$model)); ?>