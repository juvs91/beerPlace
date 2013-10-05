<?php
/* @var $this BeerController */
/* @var $dataProvider CActiveDataProvider */

$this->breadcrumbs=array(
	'Beers',
);

$this->menu=array(
	array('label'=>'Create Beer', 'url'=>array('create')),
	array('label'=>'Manage Beer', 'url'=>array('admin')),
);
?>

<h1>Beers</h1>

<?php $this->widget('zii.widgets.CListView', array(
	'dataProvider'=>$dataProvider,
	'itemView'=>'_view',
)); ?>
