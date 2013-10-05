<?php
/* @var $this BeerController */
/* @var $model Beer */

$this->breadcrumbs=array(
	'Beers'=>array('index'),
	$model->name,
);

$this->menu=array(
	array('label'=>'List Beer', 'url'=>array('index')),
	array('label'=>'Create Beer', 'url'=>array('create')),
	array('label'=>'Update Beer', 'url'=>array('update', 'id'=>$model->id)),
	array('label'=>'Delete Beer', 'url'=>'#', 'linkOptions'=>array('submit'=>array('delete','id'=>$model->id),'confirm'=>'Are you sure you want to delete this item?')),
	array('label'=>'Manage Beer', 'url'=>array('admin')),
);
?>

<h1>View Beer #<?php echo $model->id; ?></h1>

<?php $this->widget('zii.widgets.CDetailView', array(
	'data'=>$model,
	'attributes'=>array(
		'id',
		'name',
		'locationid',
		'idType',
	),
)); ?>
