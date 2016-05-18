var ready;

ready = function() {
  /* Datatable for Customer Information */
  $('#users').dataTable({
    processing: true,
    serverSide: true,
    ajax: $('#users').data('source'),
    pagingType: 'full_numbers',
    oLanguage: {
       sLengthMenu: "_MENU_",
    },
    columns: [
      { searchable: true, orderable: true }, 
      { searchable: true, orderable: true },
      { searchable: false, orderable: false },
      { searchable: false, orderable: false }
    ],
  });

  /* Datatable for Shopkeeper Information */
  $('#shop_profiles').dataTable({
    processing: true,
    serverSide: true,
    ajax: $('#shop_profiles').data('source'),
    pagingType: 'full_numbers',
    oLanguage: {
       sLengthMenu: "_MENU_",
    },
    columns: [
      { searchable: true, orderable: true },
      { searchable: true, orderable: true }, 
      { searchable: false, orderable: false },
      { searchable: false, orderable: false },
      { searchable: false, orderable: false }
    ],
  });

  /* Datatable for Global Product Bank Information */
  $('#products').dataTable({
    processing: true,
    serverSide: true,
    ajax: $('#products').data('source'),
    pagingType: 'full_numbers',
    oLanguage: {
       sLengthMenu: "_MENU_",
    },
    columns: [ 
      { searchable: true, orderable: true },
      { searchable: false, orderable: false },
    ] 
  });

};

$(document).ready(ready);
$(document).on('page:load', ready);
