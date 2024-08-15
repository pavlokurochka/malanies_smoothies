# Import python packages
import streamlit as st
from snowflake.snowpark.context import get_active_session
from snowflake.snowpark.functions import col


# Write directly to the app
st.title("Zena's Amazing Athleisure Catalog")
# st.subheader("Pick sweatshit color and style:")
# st.write(
#     """Replace this example with your own code!
#     **And if you're new to Streamlit,** check
#     out our easy-to-follow guides at
#     [docs.streamlit.io](https://docs.streamlit.io).
#     """
# )

# Get the current credentials
session = get_active_session()
# color_or_style_lov = session.table("ZENAS_ATHLEISURE_DB.PRODUCTS.CATALOG_FOR_WEBSITE").select(col('COLOR_OR_STYLE'))

table_colors = session.sql("select color_or_style from catalog_for_website")
color_or_style_lov = table_colors.to_pandas()

selected_sweatshirt = st.selectbox("Pick sweatshit color and style:",color_or_style_lov)
if selected_sweatshirt:
    
    mdf =session.sql(f"select * from ZENAS_ATHLEISURE_DB.PRODUCTS.CATALOG_FOR_WEBSITE where COLOR_OR_STYLE = '{selected_sweatshirt}' ").collect()[0]
    # df = my_dataframe.to_pandas() 
    # sweatshirt = df.to_dict()
    # st.dataframe(mdf, use_container_width=True)
    st.image(mdf.FILE_URL)
    st.caption(f"""Our warm, comfortable, {mdf.COLOR_OR_STYLE} swearshirt!""")
    st.markdown('**Price:** ' + str(mdf.PRICE))
    st.markdown(f"""**Sizes Available:** {mdf.SIZE_LIST} """)
    st.markdown('**Also Consider:** ' + mdf.UPSELL_PRODUCT_DESC)

