<?php
/* @var $this RatingController */
/* @var $model Rating */
/* @var $form CActiveForm */
?>

<div class="form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'id'=>'rating-form',
	'enableAjaxValidation'=>false,
)); ?>

	<p class="note">Fields with <span class="required">*</span> are required.</p>

	<?php echo $form->errorSummary($model); ?>

	<div class="row">
		<?php echo $form->labelEx($model,'stars'); ?>
		<?php echo $form->textField($model,'stars'); ?>
		<?php echo $form->error($model,'stars'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'idBeer'); ?>
		<?php echo $form->textField($model,'idBeer'); ?>
		<?php echo $form->error($model,'idBeer'); ?>
	</div>

	<div class="row buttons">
		<?php echo CHtml::submitButton($model->isNewRecord ? 'Create' : 'Save'); ?>
	</div>

<?php $this->endWidget(); ?>

</div><!-- form -->