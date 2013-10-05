<?php
/* @var $this BeerController */
/* @var $model Beer */
/* @var $form CActiveForm */
?>

<div class="form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'id'=>'beer-form',
	'enableAjaxValidation'=>false,
)); ?>

	<p class="note">Fields with <span class="required">*</span> are required.</p>

	<?php echo $form->errorSummary($model); ?>

	<div class="row">
		<?php echo $form->labelEx($model,'name'); ?>
		<?php echo $form->textField($model,'name',array('size'=>60,'maxlength'=>250)); ?>
		<?php echo $form->error($model,'name'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'locationid'); ?>
		<?php echo $form->textField($model,'locationid'); ?>
		<?php echo $form->error($model,'locationid'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'idType'); ?>
		<?php echo $form->textField($model,'idType'); ?>
		<?php echo $form->error($model,'idType'); ?>
	</div>

	<div class="row buttons">
		<?php echo CHtml::submitButton($model->isNewRecord ? 'Create' : 'Save'); ?>
	</div>

<?php $this->endWidget(); ?>

</div><!-- form -->