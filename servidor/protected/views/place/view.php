<?php
/* @var $this PlaceController */
/* @var $model Place */

$this->breadcrumbs=array(
	'Places'=>array('index'),
	$model->id,
);

$this->menu=array(
	array('label'=>'List Place', 'url'=>array('index')),
	array('label'=>'Create Place', 'url'=>array('create')),
	array('label'=>'Update Place', 'url'=>array('update', 'id'=>$model->id)),
	array('label'=>'Delete Place', 'url'=>'#', 'linkOptions'=>array('submit'=>array('delete','id'=>$model->id),'confirm'=>'Are you sure you want to delete this item?')),
	array('label'=>'Manage Place', 'url'=>array('admin')),
);
?>

<h1>View Place #<?php echo $model->id; ?></h1>

<?php $this->widget('zii.widgets.CDetailView', array(
	'data'=>$model,
	'attributes'=>array(
		'id',
		'idLocation',
		'latitude',
		'idBeer',
	),
)); ?>
