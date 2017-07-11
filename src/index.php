<?php
if (!class_exists('Timber')){
    echo 'Timber not activated. Make sure you activate the plugin in <a href="/wp-admin/plugins.php#timber">/wp-admin/plugins.php</a>';
    return;
}

$data = Timber::get_context();
$data['posts'] = Timber::get_posts();
Timber::render('/views/index.twig', $data);
