// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application";
import NabarController from "./navbar_controller";
import RosterController from "./roster_controller";
import DropdownController from "./dropdown_controller";
import StickyHeroController from "./sticky_hero_controller";
import InPageNavController from "./in_page_nav_controller";
import IntegerController from "./integer_controller";
import EventBookingFormController from "./event_booking_form_controller";
import PaymentController from "./payment_controller";
import FlashController from "./flash_controller";

application.register("navbar", NabarController);
application.register("roster", RosterController);
application.register("dropdown", DropdownController);
application.register("sticky", StickyHeroController);
application.register("in-page-nav", InPageNavController);
application.register("integer", IntegerController);
application.register("booking-form", EventBookingFormController);
application.register("payment", PaymentController);
application.register("flash", FlashController);
