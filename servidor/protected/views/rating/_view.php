<?php
/* @var $this RatingController */
/* @var $data Rating */
?>

<div class="view">

	<b><?php echo CHtml::encode($data->getAttributeLabel('id')); ?>:</b>
	<?php echo CHtml::link(CHtml::encode($data->id), array('view', 'id'=>$data->id)); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('stars')); ?>:</b>
	<?php echo CHtml::encode($data->stars); ?>
	<br />

	<b><?php echo CHtml::encode($data->getAttributeLabel('idBeer')); ?>:</b>
	<?php echo CHtml::encode($data->idBeer); ?>
	<br />


</div>