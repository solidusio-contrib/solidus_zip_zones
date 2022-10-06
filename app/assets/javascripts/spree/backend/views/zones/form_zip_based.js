$(function(){
  if($('.js-zones-form').length){
    Spree.Views.Zones.FormZipBased = Backbone.View.extend({
      events: {
        'click [name="zone[kind]"]': 'render'
      },

      render: function() {
        var kind = this.$('[name="zone[kind]"]:checked').val() || 'state';

        $('#zip_members').toggleClass('hidden', kind !== 'zip_code');
        $('#zip_members :input').prop('disabled', kind !== 'zip_code');
      }
    })

    var view = new Spree.Views.Zones.FormZipBased({
      el: $('.js-zones-form')
    });
    view.render()
  } else {
    $('#country_based, #state_based').click(function(){
      $('#zip_members #zone_zip_code_ids').prop('disabled', true)
      $('#zip_members').hide()
    })

    $('#zip_code_based').click(function(){
      $('#zip_members #zone_zip_code_ids').prop('disabled', false)
      $('#zip_members').show()

      $('#country_members :input, #state_members :input').each(function(){
        $(this).prop('disabled', true)
      })
      $('#country_members, #state_members').hide()
    })

    if($('#zip_code_based[data-is-zip-based=true]').length > 0){
      $('#zip_code_based').click()
    } else {
      $('#zip_members').hide()
    }
  }

  $(".select2-taggable").select2({
    tags: true,
    tokenSeparators: [',', ' ']
  })
})
