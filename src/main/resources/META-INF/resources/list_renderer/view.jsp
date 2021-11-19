<%@ page import="com.liferay.commerce.product.content.util.CPContentHelper" %>
<%@ page import="com.liferay.commerce.product.content.constants.CPContentWebKeys" %>
<%@ page import="com.liferay.commerce.product.util.CPInstanceHelper" %>
<%@ page import="com.liferay.portal.kernel.util.GetterUtil" %>
<%@ page import="com.liferay.commerce.product.data.source.CPDataSourceResult" %>
<%@ page import="com.liferay.commerce.product.constants.CPWebKeys" %>
<%@ page import="com.liferay.commerce.product.catalog.CPCatalogEntry" %>
<%@ page import="com.liferay.commerce.context.CommerceContext" %>
<%@ page import="com.liferay.commerce.constants.CommerceWebKeys" %>
<%@ page import="com.liferay.commerce.product.catalog.CPSku" %>
<%@ page import="com.liferay.commerce.product.model.CPDefinitionSpecificationOptionValue" %>
<%@ page import="com.liferay.portal.kernel.util.PortalUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="com.liferay.commerce.product.content.util.CPMedia" %>
<%@ page import="com.liferay.commerce.demo.ess.renderer.display.context.RendererDisplayContext" %>
<%@ include file="/META-INF/resources/init.jsp" %>

<%
    CPContentHelper cpContentHelper = (CPContentHelper)request.getAttribute(CPContentWebKeys.CP_CONTENT_HELPER);
    CPDataSourceResult cpDataSourceResult = (CPDataSourceResult)request.getAttribute(CPWebKeys.CP_DATA_SOURCE_RESULT);
    List<CPCatalogEntry> cpCatalogEntries = cpDataSourceResult.getCPCatalogEntries();
    RendererDisplayContext rendererDisplayContext = (RendererDisplayContext)request.getAttribute("rendererDisplayContext");
%>

<style>

    .product-list{
        display:flex;
        flex-wrap:wrap;
        justify-content: center;
    }

    .minium-frame .quantity-selector {
        display: none;
    }

    .spacer-line {
        margin: 20px 0;
        border-bottom: 1px solid #ddd;
        padding: 0 0 20px;
    }

    .plan-description {
        color: #474B55;
        font-weight: 300;
        font-size:18px;
        line-height: 28px;
    }

    .price-value {
        font-size: 1.667em;
        letter-spacing: -0.44px;
        color: #003863;
    }

    .summary-of-benefits {
        text-decoration: none;
        font-size: 18px;
        font-weight: 500;
        letter-spacing: -0.2px;
        color: #003863;
    }

    td.spec-table-cell {
        height: 70px;
    }

    .price {
        height: 140px;
    }

    .progress {
        margin-bottom: 1rem;
        margin-top: -1rem;
        margin-right: -.9rem;
        margin-left: -1.6em;
    }

    .spec-label{
        font-size: 18px;
        line-height: 26px;
        color: #003863;
        font-weight: 500;
    }

    .spec-value {
        color: #474B55;
        font-weight: 300;
        line-height: 28px;
        margin: 0 0 10px;
        font-size: 18px;

    }


</style>

<c:choose>
    <c:when test="<%= !cpCatalogEntries.isEmpty() %>">
        <div class="product-list">
        <%
            for (CPCatalogEntry cpCatalogEntry : cpCatalogEntries) {
                String friendlyURL = cpContentHelper.getFriendlyURL(cpCatalogEntry, themeDisplay);
                CPSku cpSku = cpContentHelper.getDefaultCPSku(cpCatalogEntry);

                long cpDefinitionId = cpCatalogEntry.getCPDefinitionId();
                String addToCartId = PortalUtil.generateRandomKey(request, "add-to-cart");

                List<CPDefinitionSpecificationOptionValue> cpDefinitionSpecificationOptionValues =
                        cpContentHelper.getCPDefinitionSpecificationOptionValues(cpDefinitionId);

                List<CPDefinitionSpecificationOptionValue> generalItems = rendererDisplayContext.getSpecificationsByGroup(cpDefinitionId, "general-info");
                List<CPMedia> cpAttachmentFileEntries = cpContentHelper.getCPAttachmentFileEntries(cpDefinitionId, themeDisplay);

                String topBarColor = "blue";
                String planeName = cpCatalogEntry.getName();

                if (planeName.toLowerCase().contains("green")){
                    topBarColor = "#529535";
                }else if (planeName.toLowerCase().contains("bronze")){
                    topBarColor = "#f08811";
                }else if (planeName.toLowerCase().contains("silver")){
                    topBarColor = "#848991";
                }else if (planeName.toLowerCase().contains("gold")){
                    topBarColor = "#f0b211";
                }else if (planeName.toLowerCase().contains("platinum")){
                    topBarColor = "#d8d8d8";
                }
        %>
            <div class="col-12 col-md-3 pt-2 pb-2">
                <div class="card card-lg shadow-hover product-card">
                    <div class="card-body  text-center" style="border-top: 8px solid <%= topBarColor%>;">

                        <commerce-ui:compare-checkbox
                                CPCatalogEntry="<%= cpCatalogEntry %>"
                        />

                        <!-- Product Name -->
                        <h4 class="darkblue"><a href="<%= friendlyURL%>"><%= cpCatalogEntry.getName() %></a></h4>

                        <div id="<portlet:namespace />thumbs-container">

                            <%
                                for (CPMedia cpMedia : cpContentHelper.getImages(cpDefinitionId, themeDisplay)) {
                            %>

                            <div class="card thumb" data-url="<%= HtmlUtil.escapeAttribute(cpMedia.getURL()) %>">
                                <img class="center-block img-fluid" src="<%= HtmlUtil.escapeAttribute(cpMedia.getURL()) %>" />
                            </div>

                            <%
                                }
                            %>

                        </div>

                        <p class="plan-description"><%= cpCatalogEntry.getShortDescription()%></p>

                        <!-- Price -->
                        <commerce-ui:price
                                compact="<%= true %>"
                                CPCatalogEntry="<%= cpCatalogEntry %>"
                        />

                        <p class="summary-of-benefits">Summary of Benefits and Coverage</p>


                        <%
                            if (cpAttachmentFileEntries.size() > 0){
                                CPMedia curCPAttachmentFileEntry = cpAttachmentFileEntries.get(0);
                        %>

                        <aui:icon cssClass="icon-monospaced" image="download" markupView="lexicon" target="_blank"
                                  url="<%= curCPAttachmentFileEntry.getDownloadURL()%>" />
                        <%
                            }
                        %>

                        <!-- Add to Cart Button -->
                        <c:choose>
                            <c:when test="<%= cpSku != null %>">
                                <commerce-ui:add-to-cart
                                        block="<%= true %>"
                                        CPCatalogEntry="<%= cpCatalogEntry %>"
                                />
                            </c:when>
                            <c:otherwise>
                                <a class="commerce-button commerce-button--outline w-100" href="<%= friendlyURL %>">
                                    <liferay-ui:message key="view-all-variants" />
                                </a>
                            </c:otherwise>
                        </c:choose>

                        <!-- Product Specs -->
                        <table class="table table-striped">
                        <%
                            for (CPDefinitionSpecificationOptionValue cpDefinitionSpecificationOptionValue : generalItems) {
                                CPSpecificationOption cpSpecificationOption = cpDefinitionSpecificationOptionValue.getCPSpecificationOption();
                                String specLabel = cpSpecificationOption.getTitle(languageId);
                                String specValue = cpDefinitionSpecificationOptionValue.getValue(languageId);
                        %>
                            <tr>
                                <td class="spec-table-cell">
                                    <div class="spec-label"><%= specLabel%></div>
                                    <div class="spec-value"><%= specValue%></div>
                                </td>
                            </tr>
                        <%
                            }
                        %>
                        </table>
                    </div>
                </div>
            </div>
        <%
            }
        %>
        </div>
    </c:when>
    <c:otherwise>
        <div class="alert alert-info">
            <liferay-ui:message key="no-products-were-found" />
        </div>
    </c:otherwise>
</c:choose>