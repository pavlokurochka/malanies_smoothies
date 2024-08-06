# Import python packages
import streamlit as st
# from snowflake.snowpark.context import get_active_session
from snowflake.snowpark.functions import col
import requests



# Write directly to the app
st.title(" :cup_with_straw: Customize Your Smoothie!🍹")




name_on_order = st.text_input('Name on Smoothie:')
st.write("The name on Smoothie will be:", name_on_order)

st.write(
    """Choose the fruits you want in your custom Smoothie!
    """
)


# session = get_active_session()
cnx = st.connection('snowflake')
session = cnx.session()
my_dataframe = session.table("smoothies.public.fruit_options").select(col('FRUIT_NAME'), col('SEARCH_ON'))
# st.dataframe(data=my_dataframe, use_container_width=True)
# st.stop()
pd_df = my_dataframe.to_pandas()
ingredients_list = st.multiselect('Choose up to 5 ingredients:', my_dataframe, max_selections=5)
if ingredients_list:
    # st.write(ingredients_list)
    # st.text(ingredients_list)
    for fruit_chosen in ingredients_list:
        search_on=pd_df.loc[pd_df['FRUIT_NAME'] == fruit_chosen, 'SEARCH_ON'].iloc[0]
        st.write('The search value for ', fruit_chosen,' is ', search_on, '.')
        st.subheader(f'{fruit_chosen} Nutritional Information')
        fruityvice_response = requests.get(f"https://fruityvice.com/api/fruit/{search_on}")
        # st.text(fruityvice_response)
        fv_df = st.dataframe(data=fruityvice_response.json(), use_container_width=True)
    ingredients_string = ' '.join(ingredients_list)
    # st.write(ingredients_string)
    my_insert_stmt = """ insert into smoothies.public.orders(ingredients, name_on_order, ORDER_FILLED)
            values ('""" + ingredients_string + """', '""" +  name_on_order + """'
           , 0 )"""
    time_to_insert = st.button('Submit Order')
    # st.write(my_insert_stmt)
    if ingredients_string and time_to_insert:
       session.sql(my_insert_stmt).collect()
       st.success(f'Your Smoothie is ordered, {name_on_order}!', icon="✅")
