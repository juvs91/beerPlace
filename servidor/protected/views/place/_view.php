<?php
/* @var $this PlaceController */
/* @var $data Place */
?>

<div class="view">

	<b><?php echo CHtml::encode($data->getAttributeLabel('id')); ?>:</b>
	<?php echo CHtml::link(CHtml::encode($data->id), array('view', 'id'=>$data->id)); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('idLocation')); ?>:</b>
	<?php echo CHtml::encode($data->idLocation); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('latitude')); ?>:</b>
	<?php echo CHtml::encode($data->latitude); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('idBeer')); ?>:</b>
	<?php echo CHtml::encode($data->idBeer); ?>
	<br />


</div>