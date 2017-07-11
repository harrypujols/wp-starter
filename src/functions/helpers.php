<?php

add_action( 'wp_loaded', 'inline_svg', 1 );
function inline_svg($file = null) {
  $icon_path =  get_template_directory()  . '/static/icons/' . $file;
  if (file_exists($icon_path)) {
    $svg = file_get_contents($icon_path);
    $svg = preg_replace('!^[^>]+>(\r\n|\n)!', '', $svg);
    $svg = preg_replace('~<(?:!DOCTYPE|/?(?:html|body))[^>]*>\s*~i', '', $svg);
    return $svg;
  }
}
