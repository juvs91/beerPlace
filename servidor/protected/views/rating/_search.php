<?php
/* @var $this RatingController */
/* @var $model Rating */
/* @var $form CActiveForm */
?>

<div class="wide form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'action'=>Yii::app()->createUrl($this->route),
	'method'=>'get',
)); ?>

	<div class="row">
		<?php echo $form->label($model,'id'); ?>
		<?php echo $form->textField($model,'id'); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'stars'); ?>
		<?php echo $form->textField($model,'stars'); ?>
	</div>

	<div class="row">
		<?php echo $form->label($model,'idBeer'); ?>
		<?php echo $form->textField($model,'idBeer'); ?>
	</div>

	<div class="row buttons">
		<?php echo CHtml::submitButton('Search'); ?>
	</div>

<?php $this->endWidget(); ?>

</div><!-- search-form -->