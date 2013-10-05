<?php
/* @var $this PlaceController */
/* @var $model Place */
/* @var $form CActiveForm */
?>

<div class="form">

<?php $form=$this->beginWidget('CActiveForm', array(
	'id'=>'place-form',
	'enableAjaxValidation'=>false,
)); ?>

	<p class="note">Fields with <span class="required">*</span> are required.</p>

	<?php echo $form->errorSummary($model); ?>

	<div class="row">
		<?php echo $form->labelEx($model,'idLocation'); ?>
		<?php echo $form->textField($model,'idLocation'); ?>
		<?php echo $form->error($model,'idLocation'); ?>
	</div>

	<div class="row">
		<?php echo $form->labelEx($model,'latitude'); ?>
		<?php echo $form->textField($model,'latitude',array('size'=>60,'maxlength'=>1024)); ?>
		<?php echo $form->error($model,'latitude'); ?>
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