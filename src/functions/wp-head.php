<?php
/*
******************************************************************
Register User Scripts
******************************************************************
*/

add_action( 'wp_enqueue_scripts', 'theme_scripts' );
function theme_scripts() {
  wp_enqueue_script('scripts-js', get_template_directory_uri() .'/scripts.js', array('jquery'), null, true);
}
