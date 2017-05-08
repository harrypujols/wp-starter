<?php
$data = Timber::get_context();
$data['post'] = new TimberPost();
Timber::render('/views/single.twig', $data);
