<?php
/* @var $this BeerController */
/* @var $data Beer */
?>

<div class="view">

	<b><?php echo CHtml::encode($data->getAttributeLabel('id')); ?>:</b>
	<?php echo CHtml::link(CHtml::encode($data->id), array('view', 'id'=>$data->id)); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('name')); ?>:</b>
	<?php echo CHtml::encode($data->name); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('locationid')); ?>:</b>
	<?php echo CHtml::encode($data->locationid); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('idType')); ?>:</b>
	<?php echo CHtml::encode($data->idType); ?>
	<br />


</div>