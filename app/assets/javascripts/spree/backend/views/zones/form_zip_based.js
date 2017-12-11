$(function(){
  if($('.js-zones-form').length){
    Spree.Views.Zones.FormZipBased = Backbone.View.extend({
      events: {
        'click [name="zone[kind]"]': 'render'
      },

      render: function() {
        var kind = this.$('[name="zone[kind]"]:checked').val() || 'state';

        $('#zip_members').toggleClass('hidden', kind !== 'zip');
        $('#zip_members :input').prop('disabled', kind !== 'zip');
      }
    })

    var view = new Spree.Views.Zones.FormZipBased({
      el: $('.js-zones-form')
    });
    view.render()
  } else {
    $('#country_based, #state_based').click(function(){
      $('#zip_members #zone_zipcodes').prop('disabled', true)
      $('#zip_members').hide()
    })

    $('#zip_based').click(function(){
      $('#zip_members #zone_zipcodes').prop('disabled', false)
      $('#zip_members').show()

      $('#country_members :input, #state_members :input').each(function(){
        $(this).prop('disabled', true)
      })
      $('#country_members, #state_members').hide()
    })

    if($('#zone_zipcodes').val() != ''){
      $('#zip_based').click()
    } else {
      $('#zip_members').hide()
    }
  }

  $(".select2-taggable").select2({
    tags: true,
    tokenSeparators: [',', ' ']
  })
})
