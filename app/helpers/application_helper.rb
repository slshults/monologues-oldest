# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def user_link
    return session_user_link if @current_user
    sessionless_user_link
  end

  def session_user_link
      "<div class='user_session_link'>" +
      "Logged In as: #{@current_user.name} - " +
      "<small>" + link_to('logout', '/logout') + "</small></div>"
  end

  def sessionless_user_link
      '<div class="user_session_link"><small>Not Logged In</small></div>'
      # link_to("Sign Up", new_user_path)
      # link_to("Login", new_login_path)
  end


  def link_to_monologue( monologue )
    if monologue.body
      link_to( monologue.first_line, monologue )
    else
      "<span class='no-link'>#{monologue.first_line}</span>"
    end
  end

  def link_to_monologue_pdf( monologue )
    if monologue.pdf_link
      "<a href='#{monologue.pdf_link}' target='_blank')><img title='pdf' alt='pdf' valign='middle' src='/images/print.gif' border='0' /></a>"
    else
      "<img title='pdf' alt='pdf' valign='middle' src='/images/print_x.gif' border='0' />"
    end
  end

  def link_to_monologue_location( monologue )
    if monologue.body_link
      "<a href='#{h monologue.body_link}' target='_blank'>#{h monologue.location}</a>"
    else
      h monologue.body_link
    end
  end

  def paypal_image_form
    %q^<form style='display:inline;' name='PaypalForm' action='https://www.paypal.com/cgi-bin/webscr' method='post' onsubmit='includeemail()'>
    <font face=verdana size='-2'>Tip Jar</font><br/>
    <input type='hidden' name='cmd' value='_xclick'/>
    <input type='hidden' name='business' value=''/>
    <input type='hidden' name='item_name' value='Shakespeare's Monologues Donations'/>
    <input type='hidden' name='item_number' value='031806'/>
    <input type='hidden' name='no_shipping' value='1'/>
    <input type='hidden' name='return' value='http://shakespeare-monologues.org/thanks.htm'/>
    <input type='hidden' name='cn' value='Include a note if you like:'/>
    <input type='hidden' name='currency_code' value='USD'/>
    <input type='hidden' name='tax' value='0'/>
    <input type='hidden' name='lc' value='US'/>
    <input type='hidden' name='bn' value='PP-DonationsBF'/>
    <input type='image' src='https://www.paypal.com/en_US/i/btn/x-click-but04.gif' border='0' name='submit' alt='Make payments
    with PayPal - it's fast, free and secure!'/>
    <img alt='Tip Jar' border='0' src='https://www.paypal.com/en_US/i/scr/pixel.gif' width='1' height='1'/></form>^
  end
end
