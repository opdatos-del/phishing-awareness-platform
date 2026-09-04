-- V8: Agregar constraint UNIQUE compuesto campaign_id + recipient_id
-- y ajustar campaign_events para que event_time se gestione por la aplicación
ALTER TABLE campaign_recipients
    ADD CONSTRAINT uq_cr_campaign_recipient UNIQUE (campaign_id, recipient_id);
