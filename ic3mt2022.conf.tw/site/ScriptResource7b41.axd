// Name:        Seadragon.Seadragon.Config.debug.js
// Assembly:    AjaxControlToolkit
// Version:     4.1.7.725
// FileVersion: 4.1.7.0725
// (c) 2010 CodePlex Foundation
Type.registerNamespace('Sys.Extended.UI.Seadragon');
Type.registerNamespace('Seadragon');
Sys.Extended.UI.Seadragon.Config = function() {

    this.debugMode = true;

    this.animationTime = 1.5;

    this.blendTime = 0.5;

    this.alwaysBlend = false;

    this.autoHideControls = true;

    this.immediateRender = false;

    this.wrapHorizontal = false;

    this.wrapVertical = false;

    this.minZoomDimension = 0.8;

    this.maxZoomPixelRatio = 2;

    this.visibilityRatio = 0.5;

    this.springStiffness = 5.0;

    this.imageLoaderLimit = 2;

    this.clickTimeThreshold = 200;

    this.clickDistThreshold = 5;

    this.zoomPerClick = 2.0;

    this.zoomPerSecond = 2.0;

    this.showNavigationControl = true;

    this.maxImageCacheCount = 100;

    this.minPixelRatio = 0.5;

    this.mouseNavEnabled = true;

    this.navImages = {
        zoomIn: {
            REST: 'WebResource.axd?d=gExzrzD9JcrNzjDJWY76Rt-wR-T_mZGaNR6ud0yqshuZghyi7aTP_vBujXxFUdocwSCi8GnHXmPUVck0tPbTyNulewLZfXd494HgQBZM4Xx4uFALODTSKq-w_RBxz30ZdnzMtw2&t=635154913704088000',
            GROUP: 'WebResource.axd?d=DbGV8nfyf23V8NVvdxo7J4BbqdxBi5UjcDkLwLmJO6qLy_lNui51ILLR_FZfYnnayv1Iv1rb1ZaTdHq51U5w9R8YSavia2JHmC6J9Siw8EurveWaZ2I5Mo4TrrQKjp7PPmrEDqjg9b7L103AJLpZbAAKe-k1&t=635154913704088000',
            HOVER: 'WebResource.axd?d=J1j0t_uy__q7ITyrqJGsFR7Nmy0qHzXzhkEd-UcJYXPKtiwKX8WJlqIMxDfbO7r6cNjOCWwvuIsliy9MTRXAh13xKPtZ9wZNQo4WdtL8jRmuRI-2PIohfF_iPlmftn7orgFUnA2&t=635154913704088000',
            DOWN: 'WebResource.axd?d=jFGZD5UoZkUqfOEz7f-FKIyUousTtY8pOdr9h9W12M0Q2aj7KqwbMQ1SFiOlGh9mKCpZUXjKtIIYCcyuU33BS514oFo0GyQHyg3xfePNjj9M9XaK6LuUd2wcjevD5QmK5gobhQ2&t=635154913704088000'
        },
        zoomOut: {
            REST: 'WebResource.axd?d=pKv-PhEL-uZfvgPrbG45QM20te6eH7j_0ESpxMZAh1HMDvhIufPkiwQ96Jv9gtkjAs7Sf2GfdRmaPQqqwRXTLIs78mKEaCLs1HU5y9S1F3tqioVxoMVtRGUms2Z4rrrIQjXXug2&t=635154913704088000',
            GROUP: 'WebResource.axd?d=5tuxdEMh1NDg7xIAzOBxIP929vOcyk-WQDv0aJvTVsT1O52iiqiZxAwsmlL2sQkqw_a8kjC0PcEmG6ipL_GOUb4CWsqzN3veW4v8DKEYrJJr-jpqWClB3AQV1dCVEeMZeURDMC13UHItfJX_X4gh7y43pw81&t=635154913704088000',
            HOVER: 'WebResource.axd?d=sfBmZAtuIz-PqLE5Wofn8e3nyAC77ESm_nNN1O-J2MuA7rjIeHUMpkEIY40Xry7Iu8DRyH0U8GIV_XBWmnMzogKMwrEb_KfBncCnCUAZwQ7TqY53JnHjcTfHfd2UJb2ZxAGuyw2&t=635154913704088000',
            DOWN: 'WebResource.axd?d=6JoF59-sB1iFUUBkOlrfsphDg2Fv-Nx1gnmCpkqUqD54j08g5xBVadWYXGwK8vDc6oP-Hf8MCk1JFBWaOJ9DZanKw47A_Qb0kLOrpNytnrza8U-otvkDmc3Vj6LSs7baCZCb-CHWV5-bYc0GGCVHVV319pM1&t=635154913704088000'
        },
        home: {
            REST: 'WebResource.axd?d=SeYKpzUpCUn4GYcd3IVyBXvwXMdjynvNpnqnHoiGa70srUJlPoFwAZA6c5Ct_EX1k1FQ3diE7ehJHD89LAa3BfqmOu7-iIW4J6Gz4fsuarI_WVXl1VFgXCy5YZrR54x4Y91i2w2&t=635154913704088000',
            GROUP: 'WebResource.axd?d=HqXMyHbzEVVm2oGvY7IZKG5GxwTx0ZV4iqa9k7WG-Wl2lTbi2cpk34nlqkxxOeYZuEWB1Jljx8BBY_8ceCLmKj5NtmkhJy3PKDbB2k-FyK9dgQS8sWgvX8fhF4B0czh3sLAe_11ZNSwfCdvBwyj_og2z3Is1&t=635154913704088000',
            HOVER: 'WebResource.axd?d=egGb_wqXuGD-8D0zeJyYKpVeH8jRV4LZp_YLImlQa4Cv6fpDOmyLGFBkCbfZgzra2raVoAaizxrX627qXmmL_MDSD0l2IbMKWvNm9kkWR-b4ODJSFdxWGopO7lu9H2lon8MK6g2&t=635154913704088000',
            DOWN: 'WebResource.axd?d=LXmVmBK08JFr3Gr8lJFFYS9Y1OSTtm6mDelv7BDq_z5H-gTS9pDewaCEsvvrWKcS5cJ91g0u4vRdQFEF46UgMAeiLz9_sAxUlrwsXYQutBfutx1ANs-ZdQTRENYss1NyVC3Bog2&t=635154913704088000'
        },
        fullpage: {
            REST: 'WebResource.axd?d=YhNrGzvqvTR4dAuvZ4OcMfLJTxmCpqqxYpqRs-MMISwGB4qjKlD2rCHlbdxlgEbNx-SbN1WgasbwbmOU1jwoRrIDOAry4BN9rt134M8m9GDtjDudZzTVqEtmfDyoB2ydXY09tw2&t=635154913704088000',
            GROUP: 'WebResource.axd?d=KTRKt550SWqezF5baXTMsTvE-zsT51LZMnJ5MdtZ73NK3g6BQLE7HXwN_1R1addAUZsTmIS6LY4QjcCprOxqzvi4XtnXUkwz7VNrDXj39qpa8IsybxGlx7IsfABXQJase0gWOUlnFchBURlPxzcPMvi7v1I1&t=635154913704088000',
            HOVER: 'WebResource.axd?d=Kl7y81swFo2Tqm5TLUpDCqAa9rfjUvbNZ97MlqRGdSUrljFiUd9FFEQugwNi97-uh7EtjA0j6Qq5ZndTTpcahv2XtYnoYWEYQQlP-qlOv8yS-2NvpogL4K0UiZ6PFBtHr4EoOQ2&t=635154913704088000',
            DOWN: 'WebResource.axd?d=uH_ekb-jo7XiCjTqSgmnqHY9K6usR8UutCw8TMSbFXv73GKm8s2_3XczkEWv7-fOqoJdaQ-Rl4qbO-edK0MSxJjIcaYlwC-esvmJGgjoKUouE64Yk_A4NM2UJnntrTnPC-eXULph0H5TnTLyODB2tUIkHNs1&t=635154913704088000'
        }
    };
};
Sys.Extended.UI.Seadragon.Config.registerClass('Sys.Extended.UI.Seadragon.Config', null, Sys.IDisposable);
