<?php
/* @var $this BeerController */
/* @var $model Beer */

$this->breadcrumbs=array(
	'Beers'=>array('index'),
	$model->name=>array('view','id'=>$model->id),
	'Update',
);

$this->menu=array(
	array('label'=>'List Beer', 'url'=>array('index')),
	array('label'=>'Create Beer', 'url'=>array('create')),
	array('label'=>'View Beer', 'url'=>array('view', 'id'=>$model->id)),
	array('label'=>'Manage Beer', 'url'=>array('admin')),
);
?>

<h1>Update Beer <?php echo $model->id; ?></h1>

<?php echo $this->renderPartial('_form', array('model'=>$model)); ?>