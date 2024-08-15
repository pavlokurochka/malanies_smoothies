# Import python packages
import streamlit as st
from snowflake.snowpark.context import get_active_session
from snowflake.snowpark.functions import col, when_matched




# Write directly to the app
st.title(" :cup_with_straw: Pending Smoothie Orders 🍹")


session = get_active_session()
# my_dataframe = session.table("smoothies.public.orders").filter(col("ORDER_FILLED")==0).collect()
my_dataframe =session.sql('select order_uid, order_filled, name_on_order, ingredients from  smoothies.public.orders where ORDER_FILLED = 0').collect()
# st.dataframe(data=my_dataframe, use_container_width=True)
if my_dataframe:

    editable_df = st.data_editor(my_dataframe)
    # st.list(my_dataframe)
    submitted = st.button('Submit')
    
    if submitted:
        og_dataset = session.table("smoothies.public.orders")
        # st.write(og_dataset)
        edited_dataset = session.create_dataframe(editable_df)
        # st.write(edited_dataset)
        try:
            og_dataset.merge(edited_dataset
                                 , (og_dataset['ORDER_UID'] == edited_dataset['_1'])
                                 , [when_matched().update({'ORDER_FILLED': edited_dataset['_2']})]
                                                         )
            # 
            st.success('Order(s) updated', icon='👍')
            # og_dataset.merge(edited_dataset
            #                  , (og_dataset['name_on_order'] == edited_dataset['name_on_order'])
            #                  , [when_matched().update({'ORDER_FILLED': edited_dataset['ORDER_FILLED']})]
            #                 )
            # st.rerun()
        except:
            st.success('Something went wrong.')
else:
    st.success('There are no pending orders', icon='👍')
    